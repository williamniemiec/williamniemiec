# Conecte SUS - Plataforma Digital Oficial do Sistema Único de Saúde

O **Conecte SUS** é o aplicativo oficial do Ministério da Saúde que permite aos cidadãos brasileiros acessar seus dados de saúde de forma segura e centralizada através do Sistema Único de Saúde (SUS).

## 📱 Sobre o App

O Conecte SUS serve como uma plataforma digital centralizada e segura para que os cidadãos brasileiros acessem suas informações pessoais de saúde e histórico dentro da rede pública de saúde. O aplicativo visa digitalizar e simplificar o acesso a registros críticos de saúde, facilitar o gerenciamento de cuidados e fornecer documentos oficiais de saúde, como certificados de vacinação, diretamente no smartphone do usuário.

## ✨ Funcionalidades Principais

### 🏥 Acesso a Registros de Saúde
- **Cartão Nacional de Saúde Digital (CNS):** Exibe o Cartão Nacional de Saúde virtual do usuário, completo com número CNS e código QR para identificação em unidades do SUS
- **Histórico de Vacinação:** Registro digital completo de todas as vacinas administradas através do Programa Nacional de Imunizações (PNI), incluindo números de lote e datas
- **Certificado Nacional de Vacinação COVID-19:** Capacidade de visualizar e emitir o certificado oficial nacional de vacinação COVID-19 em múltiplos idiomas (Português, Inglês, Espanhol), com código QR para validação
- **Resultados de Exames e Laboratório:** Acesso aos resultados de exames laboratoriais realizados dentro da rede SUS
- **Histórico de Medicamentos:** Lista de medicamentos dispensados através do programa "Farmácia Popular"
- **Histórico de Internações Hospitalares:** Registro de internações passadas dentro da rede SUS

### 🩺 Gerenciamento de Cuidados e Serviços
- **Agendamento de Consultas:** Visualizar e gerenciar consultas agendadas dentro do sistema público de saúde
- **Serviços de Doação:**
  - **Registro de Doador de Órgãos:** Permite aos usuários registrar sua intenção de ser doador de órgãos
  - **Registro de Doador de Sangue:** Permite aos usuários se registrarem como doadores de sangue

### 🔐 Segurança e Autenticação
- **Integração Gov.br:** Login e autenticação seguros são tratados através da plataforma de login único do governo federal, Gov.br, garantindo privacidade e segurança dos dados

## 🎨 Layout e Componentes

### Navegação Principal (Barra de Abas Inferior)
Uma barra de abas persistente na parte inferior fornece acesso às seções principais do aplicativo:
- **Início:** O painel principal e tela de entrada
- **Ações:** Um menu de serviços e registros principais
- **Mensagens:** Uma caixa de entrada para notificações e comunicações do SUS
- **Perfil:** O perfil pessoal do usuário e configurações do aplicativo

### Telas e Componentes Principais

#### Tela de Login
- **Layout:** Um prompt simples em tela cheia
- **Componentes:** Um único botão proeminente rotulado "Entrar com Gov.br", que redireciona para o portal de autenticação do governo federal

#### Tela Inicial (Início)
- **Layout:** Uma tela estilo painel com uma grade de ícones para acesso rápido
- **Componentes:**
  - **Cabeçalho:** Exibe o nome do usuário e uma saudação
  - **Cartão de Saúde Digital:** Um botão ou cartão proeminente que abre o cartão CNS virtual
  - **Grade de Acesso Rápido:** Uma grade de ícones grandes e claramente rotulados para as funcionalidades mais importantes

#### Tela de Vacinas
- **Layout:** Uma visualização baseada em lista organizada por vacina
- **Componentes:**
  - **Lista de Vacinas:** Uma lista rolável onde cada item representa uma vacina diferente
  - **Botão de Certificado:** Um botão altamente visível para gerar o certificado oficial

## 🚀 Configuração e Instalação

### Pré-requisitos
- Flutter SDK (versão 3.8.1 ou superior)
- Dart SDK
- Android Studio / VS Code
- Chrome (para desenvolvimento web)

### Instalação

1. **Clone o repositório:**
```bash
git clone <repository-url>
cd conecte_sus_app
```

2. **Instale as dependências:**
```bash
flutter pub get
```

3. **Execute o aplicativo:**
```bash
# Para desenvolvimento web
flutter run -d chrome

# Para Android
flutter run -d android

# Para iOS
flutter run -d ios
```

## 📦 Dependências Principais

- **provider**: Gerenciamento de estado
- **http**: Requisições HTTP
- **shared_preferences**: Armazenamento local
- **qr_flutter**: Geração de códigos QR
- **pdf**: Geração de documentos PDF
- **printing**: Impressão e compartilhamento de PDFs
- **url_launcher**: Abertura de URLs externas (Gov.br)
- **intl**: Formatação de datas e internacionalização

## 🏗️ Arquitetura do Projeto

```
lib/
├── core/
│   ├── constants/          # Constantes da aplicação
│   ├── theme/             # Tema e estilos
│   └── services/          # Serviços principais
├── features/
│   ├── auth/              # Autenticação
│   ├── home/              # Tela inicial
│   ├── vaccines/          # Vacinas e certificados
│   ├── actions/           # Ações e serviços
│   ├── messages/          # Mensagens e notificações
│   └── profile/           # Perfil do usuário
├── shared/
│   ├── models/            # Modelos de dados
│   ├── widgets/           # Widgets compartilhados
│   └── services/          # Serviços compartilhados
└── main.dart              # Ponto de entrada da aplicação
```

## 🔄 Fluxo de Interação do Usuário

### 1. Primeiro Login e Acesso ao Cartão de Saúde Digital
1. O usuário baixa e abre o aplicativo Conecte SUS
2. O aplicativo exibe uma tela de boas-vindas e um único botão "Entrar com Gov.br"
3. O usuário toca no botão e é redirecionado para a interface de login do Gov.br
4. Após autenticação bem-sucedida, retorna à **Tela Inicial** do Conecte SUS
5. O usuário toca no botão "Cartão Nacional de Saúde" e visualiza seu cartão CNS virtual

### 2. Emissão do Certificado de Vacinação COVID-19
1. Na **Tela Inicial**, o usuário toca no ícone "Vacinas"
2. Na **Tela de Vacinas**, toca no botão "Certificado de Vacinação COVID-19"
3. O aplicativo gera e exibe a **Tela do Certificado de Vacinação**
4. O usuário pode exportar o certificado como PDF ou compartilhá-lo

### 3. Verificação de Resultado de Exame
1. O usuário navega para a **Tela Inicial**
2. Toca no ícone "Exames" na grade de acesso rápido
3. A **Tela de Exames** abre, exibindo uma lista de exames recentes
4. O usuário toca em um exame específico para ver os resultados detalhados

## 🛡️ Segurança e Privacidade

- **Autenticação Gov.br:** Integração com a plataforma oficial do governo brasileiro
- **Criptografia:** Todos os dados são transmitidos de forma segura
- **LGPD:** Conformidade com a Lei Geral de Proteção de Dados
- **Armazenamento Local Seguro:** Dados sensíveis são armazenados de forma criptografada

## 🎯 Funcionalidades Implementadas

- ✅ Estrutura completa do projeto Flutter
- ✅ Autenticação com Gov.br (simulada para demo)
- ✅ Navegação principal com abas
- ✅ Tela inicial com dashboard
- ✅ Tela de vacinas com histórico
- ✅ Tela de ações e serviços
- ✅ Tela de mensagens e notificações
- ✅ Tela de perfil do usuário
- ✅ Modelos de dados completos
- ✅ Tema e design system
- ✅ Gerenciamento de estado com Provider

## 🔮 Próximas Funcionalidades

- 🔄 Geração de códigos QR para documentos
- 🔄 Exportação de certificados em PDF
- 🔄 Integração real com APIs do SUS
- 🔄 Notificações push
- 🔄 Modo offline
- 🔄 Biometria para autenticação

## 🤝 Contribuição

Este é um projeto de demonstração baseado no aplicativo oficial Conecte SUS do Ministério da Saúde do Brasil.

## 📄 Licença

Este projeto é uma implementação de demonstração e não possui afiliação oficial com o Ministério da Saúde ou DATASUS.

## 📞 Suporte

Para suporte oficial do Conecte SUS, visite: https://conectesus.saude.gov.br/

---

**Desenvolvido com ❤️ usando Flutter**
