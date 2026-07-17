# Guia de Execução — rodar o sistema no seu computador

Passo a passo para colocar o MVP no ar localmente e testar o fluxo
(registrar → protocolar → tramitar). Não precisa ser programador — é seguir na ordem.

---

## Parte 1 — Instalar o Node.js (uma vez só)

1. Acesse <https://nodejs.org>.
2. Baixe a versão **LTS** (botão da esquerda) e instale (avançar → avançar → concluir).
3. Isso instala também o `npm`, que usaremos.

## Parte 2 — Baixar o código

**Opção mais fácil (ZIP):**
1. Abra o repositório no GitHub: `daviotoni/Processo-Legislativo-CMDC`.
2. No seletor de branch (canto superior esquerdo da lista de arquivos), escolha
   **`claude/municipal-chamber-structure-qo44n9`**.
3. Botão verde **Code** → **Download ZIP**.
4. Extraia o ZIP numa pasta fácil (ex.: `Documentos`).

## Parte 3 — Pegar a chave do banco (Supabase)

> Essa chave é secreta e deixa o sistema ler/gravar no banco. Fica só no seu computador.

1. Entre em <https://supabase.com/dashboard/project/yqnthodhudvzkhagozbb/settings/api>
   (faça login com a conta que criamos o projeto).
2. Na seção **Project API keys**, localize a chave **`service_role`** (marcada como *secret*).
3. Clique em **Reveal** e depois **copie** essa chave (é um texto longo).

## Parte 4 — Configurar

1. Dentro da pasta que você extraiu, entre na pasta **`web`**.
2. Copie o arquivo `.env.example` e renomeie a cópia para **`.env.local`**.
3. Abra o `.env.local` no Bloco de Notas e cole a chave depois do `=`:
   ```
   NEXT_PUBLIC_SUPABASE_URL=https://yqnthodhudvzkhagozbb.supabase.co
   SUPABASE_SERVICE_ROLE_KEY=cole_aqui_a_chave_service_role
   ```
4. Salve o arquivo.

## Parte 5 — Rodar

1. Abra o **Terminal** (Windows: "Prompt de Comando" ou "PowerShell"; Mac: "Terminal").
2. Navegue até a pasta `web`. Ex. (ajuste o caminho):
   ```
   cd Documentos/Processo-Legislativo-CMDC/web
   ```
3. Instale as dependências (só na primeira vez):
   ```
   npm install
   ```
4. Inicie o sistema:
   ```
   npm run dev
   ```
5. Abra o navegador em **<http://localhost:3000>**.

> Para parar o sistema, volte ao terminal e aperte **Ctrl + C**.

## Parte 6 — Testar o fluxo

1. No painel, clique em **+ Nova proposição**.
2. Escolha o tipo (ex.: **PL**), um autor (vereador) e escreva uma ementa. **Salvar rascunho**.
3. Na tela da proposição, clique em **Protocolar e autuar** → ela recebe número (ex.: `PL 001/2026`).
4. Use **Mover fase**, **Despachar** e **Arquivar** e veja a **linha do tempo** registrando tudo.

---

## Deu algum erro?

- **"Sem conexão com o banco"** no painel → a chave em `.env.local` está faltando ou errada
  (repita a Parte 3 e 4 e rode `npm run dev` de novo).
- **`npm` não é reconhecido** → o Node.js não foi instalado; refaça a Parte 1 e reabra o terminal.
- Qualquer outra coisa: me mande a mensagem de erro que aparece no terminal.

## Decisões que dependem de você (quando puder)

1. **Numeração do protocolo** reinicia a cada ano? Confirmar com a Secretaria-Geral.
2. **Anexo II (organograma)** em alta resolução — para desenhar as linhas de subordinação.
3. Validar o **fluxo de fases** com o Regimento Interno.
