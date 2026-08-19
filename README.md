# Consumo de água 💧

Aplicativo desenvolvido para controle do consumo diário de água. O sistema permite registrar a quantidade de água consumida, o peso atual do usuário e acompanhar a porcentagem da meta diária atingida.

## Sobre o projeto

O **Consumo de água** foi desenvolvido como parte do Desafio Mobile e Web.

A aplicação utiliza uma recomendação média de **35 ml de água por quilograma de peso corporal** para calcular a meta diária.

### Fórmula utilizada

```text
Meta diária = peso atual × 35
```

A porcentagem da meta atingida é calculada através de:

```text
Porcentagem = (quantidade consumida ÷ meta diária) × 100
```

## Funcionalidades

* Tela inicial com acesso ao aplicativo
* Opção de alternar entre tema claro e escuro
* Cadastro de consumo de água
* Registro da data do consumo
* Registro da quantidade consumida em ml
* Registro do peso atual em kg
* Exibição do total consumido no dia
* Cálculo automático da meta diária
* Cálculo da porcentagem da meta atingida
* Listagem dos registros em cartões
* Exclusão de registros
* Edição dos registros
* Armazenamento local dos dados
* Gráfico com o histórico de consumo de água
* Interface responsiva na versão Web

## Dados armazenados

Cada registro possui os seguintes campos:

| Campo              | Tipo   | Descrição                          |
| ------------------ | ------ | ---------------------------------- |
| `data`             | String | Data do consumo                    |
| `quantidade_em_ml` | double | Quantidade de água consumida em ml |
| `peso_atual_kg`    | double | Peso atual em quilogramas          |

## Versão Mobile

A versão Mobile foi desenvolvida utilizando **Flutter**.

### Tecnologias utilizadas

* Flutter
* Dart
* Shared Preferences

### Armazenamento

Os registros são armazenados localmente no dispositivo utilizando o pacote `shared_preferences`.

### Estrutura principal

```text
lib/
├── main.dart
└── ui/
    ├── splash.dart
    ├── home.dart
    └── modal_agua.dart
```

## Versão Web

A versão Web foi desenvolvida utilizando tecnologias básicas de desenvolvimento Web.

### Tecnologias utilizadas

* HTML
* CSS
* JavaScript
* LocalStorage
* Chart.js

### Estrutura principal

```text
camxcal-web/
├── css/
│   ├── style.css
│   └── home.css
│
├── html/
│   ├── index.html
│   └── home.html
│
└── js/
    ├── script.js
    └── home.js
```

## Armazenamento Web

Na versão Web, os registros são armazenados no navegador utilizando o `localStorage`.

Dessa forma, os dados permanecem salvos mesmo depois que a página é fechada.

## Gráfico

A aplicação Web possui um gráfico localizado abaixo dos cards principais.

O gráfico apresenta os registros de consumo e permite visualizar a quantidade de água consumida em cada registro.

## Requisitos funcionais

| Código | Requisito                                                                                                             | Criticidade |
| ------ | --------------------------------------------------------------------------------------------------------------------- | ----------- |
| RF001  | O sistema deve possuir uma tela Splash com um ícone, botão para trocar o tema e botão para entrar.                    | Importante  |
| RF002  | O sistema deve possuir uma tela Home com registros em cartões, botão `+` para adicionar e opção de excluir registros. | Essencial   |
| RF003  | O sistema deve exibir o total consumido no dia e a porcentagem da meta diária atingida.                               | Essencial   |
| RF004  | O sistema deve armazenar os registros localmente.                                                                     | Essencial   |
| RF005  | Ao clicar em um registro, o sistema deve permitir alterar seus dados.                                                 | Desejável   |

## Como executar o projeto Web

1. Baixe ou clone o projeto.
2. Abra a pasta do projeto no Visual Studio Code.
3. Abra o arquivo:

```text
html/index.html
```

4. Execute o projeto utilizando um servidor local, como a extensão **Live Server**.

## Como executar o projeto Mobile

1. Abra a pasta do projeto Flutter no Visual Studio Code ou Android Studio.
2. Verifique se o Flutter está instalado.
3. Execute:

```bash
flutter pub get
```

4. Depois execute:

```bash
flutter run
```

## Objetivo

O objetivo do projeto é facilitar o acompanhamento do consumo diário de água, permitindo que o usuário registre seus consumos e acompanhe seu progresso em relação à meta calculada de acordo com seu peso.

## Autor

Gabrielly Souza 👩🏽‍💻


**Consumo de Água — Controle de hidratação diária.** 💧
