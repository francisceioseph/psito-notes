// A página está em inglês no HTML, e sem JavaScript fica assim. O português mora aqui:
// cada [data-t] recebe o texto da chave, e [data-t-alt] o da descrição da imagem.
const LATEST = 'https://github.com/francisceioseph/psito-notes/releases/latest';
const SOURCE = 'https://github.com/francisceioseph/psito-notes#install';

const STRINGS = {
  en: { copied: 'Copied' },
  pt: {
    heroTitle: 'Notas autoadesivas, com calopsitas.',
    heroLead: 'Notas autoadesivas coloridas para a área de trabalho do Windows e do Linux. Sem anúncios, sem telemetria e sem conta: só as suas notas, onde você as vê.',
    install: 'Instalar',
    sourceCode: 'Código-fonte',
    lookInside: 'Por dentro',
    shotTable: 'Três notas: uma lista de compras amarela, uma nota rosa na letra simples e uma verde recolhida até o título',
    shotNote: 'O programa segue o idioma do sistema, em sete idiomas.',
    whatItDoes: 'O que ele faz',
    feature1: 'Seis papéis, duas letras e quatro tamanhos de texto, e cada nota é uma janela só dela',
    feature2: 'Negrito, itálico, sublinhado, riscado e listas, com os atalhos das notas autoadesivas clássicas',
    feature3: 'Recolha a nota até a primeira linha com um clique duplo, deixe por cima ou deixe a área de trabalho aparecer',
    feature4: 'Tudo é gravado enquanto você escreve, e as notas voltam na próxima vez que você abrir o programa',
    feature5: 'Desfazer e refazer que trazem a formatação de volta, e uma pergunta antes de uma nota com texto sumir',
    feature6: 'Funciona sem internet. Não envia nada para lugar nenhum',
    windowsIntro: 'No Windows 10 (1809 ou mais novo) ou no Windows 11, em x64. Não pede administrador.',
    windowsDownload: 'Baixar o instalador',
    windowsNote: 'O SmartScreen pode avisar que o editor é desconhecido, porque o instalador não tem um certificado pago. Escolha Mais informações e depois Executar assim mesmo.',
    debIntro: 'No Debian 13, Ubuntu 24.04, Mint 22 ou mais novos, em amd64. Ele atualiza junto com o sistema.',
    fedoraIntro: 'Em x86_64. Ele atualiza junto com o sistema. A primeira instalação pede para aceitar a chave de assinatura.',
    removeIntro: 'Para remover o programa e o repositório',
    copy: 'Copiar',
    copied: 'Copiado',
    otherNote: `Outro sistema? Você pode <a href="${LATEST}">baixar o pacote</a> ou <a href="${SOURCE}">compilar do código-fonte</a>.`,
    links: 'Links',
    issues: 'Issues',
    issuesNote: 'Relatar um problema',
    releases: 'Versões',
    releasesNote: 'O que mudou em cada versão',
    githubNote: 'O código-fonte',
    footer: 'Código sob a licença Apache 2.0, ícone sob CC0 e fontes sob a SIL Open Font License. Desenvolvido com o auxílio do Claude Code.',
  },
};

const KEY = 'psito-notes-lang';
const texts = new Map();
const alts = new Map();
for (const el of document.querySelectorAll('[data-t]')) texts.set(el, el.innerHTML);
for (const el of document.querySelectorAll('[data-t-alt]')) alts.set(el, el.alt);

function saved() {
  try { return localStorage.getItem(KEY); } catch { return null; }
}

function setLang(lang, remember) {
  const strings = STRINGS[lang];
  document.documentElement.lang = lang;
  document.getElementById('lang').value = lang;
  for (const [el, english] of texts) el.innerHTML = strings[el.dataset.t] ?? english;
  for (const [el, english] of alts) el.alt = strings[el.dataset.tAlt] ?? english;
  if (remember) {
    try { localStorage.setItem(KEY, lang); } catch {}
  }
}

const system = navigator.language.slice(0, 2).toLowerCase();
const start = saved() ?? system;
setLang(start in STRINGS ? start : 'en', false);
document.getElementById('lang').addEventListener('change', (event) => setLang(event.target.value, true));

for (const button of document.querySelectorAll('[data-copy]')) {
  button.addEventListener('click', async () => {
    try {
      await navigator.clipboard.writeText(document.getElementById(button.dataset.copy).textContent);
      button.textContent = STRINGS[document.documentElement.lang].copied;
      setTimeout(() => {
        const strings = STRINGS[document.documentElement.lang];
        button.innerHTML = strings.copy ?? texts.get(button);
      }, 1500);
    } catch {
      // Sem acesso à área de transferência, o texto continua selecionável
    }
  });
}
