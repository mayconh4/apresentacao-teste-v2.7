const ASAAS_URL = Deno.env.get("ASAAS_ENV") === "prod"
  ? "https://api.asaas.com/v3"
  : "https://api-sandbox.asaas.com/v3";
const KEY = Deno.env.get("ASAAS_API_KEY")!;

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  try {
    const { valor, nome, cpf, whatsapp, descricao } = await req.json();
    const h = { "Content-Type": "application/json", access_token: KEY };
    const doc = String(cpf || "").replace(/\D/g, "");

    // 1) cliente: reaproveita se o CPF já existe, senão cria
    const busca = await (await fetch(`${ASAAS_URL}/customers?cpfCnpj=${doc}`, { headers: h })).json();
    let customerId = busca.data?.[0]?.id;
    if (!customerId) {
      const novo = await (await fetch(`${ASAAS_URL}/customers`, {
        method: "POST", headers: h,
        body: JSON.stringify({ name: nome, cpfCnpj: doc, mobilePhone: String(whatsapp || "").replace(/\D/g, "") }),
      })).json();
      if (!novo.id) throw new Error(JSON.stringify(novo.errors || novo));
      customerId = novo.id;
    }

    // 2) cobrança PIX com vencimento hoje
    const cob = await (await fetch(`${ASAAS_URL}/payments`, {
      method: "POST", headers: h,
      body: JSON.stringify({
        customer: customerId, billingType: "PIX", value: valor,
        dueDate: new Date().toISOString().slice(0, 10), description: descricao,
      }),
    })).json();
    if (!cob.id) throw new Error(JSON.stringify(cob.errors || cob));

    // 3) QR Code + copia e cola
    const qr = await (await fetch(`${ASAAS_URL}/payments/${cob.id}/pixQrCode`, { headers: h })).json();

    return new Response(
      JSON.stringify({ paymentId: cob.id, qrImage: qr.encodedImage, copiaECola: qr.payload }),
      { headers: { ...cors, "Content-Type": "application/json" } },
    );
  } catch (e) {
    return new Response(JSON.stringify({ error: String(e) }), {
      status: 500, headers: { ...cors, "Content-Type": "application/json" },
    });
  }
});
