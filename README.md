<p align="center">
   <img src="https://github.com/user-attachments/assets/eb1a85c5-b298-4323-b55d-d37b915a6517" alt="app" width="200"/>
</p>

<h1 align="center">ConectaFERSA</h1>

<p align="center">
   <a href="https://www.linkedin.com/in/igor-sthaynny/">
      <img alt="Igor Sthaynny" src="https://img.shields.io/badge/-Sthaynny-5965e0?style=flat&logo=Linkedin&logoColor=white"/>
   </a>
  <img alt="Languages" src="https://img.shields.io/github/languages/count/Sthaynny/ufersa_hub?color=%235963C5" />
  <img alt="lastcommit" src="https://img.shields.io/github/last-commit/Sthaynny/ufersa_hub?color=%235761C3" />
  <img alt="License" src="https://img.shields.io/github/license/Sthaynny/ufersa_hub?color=%235E69D7" />
  <img alt="Issues" src="https://img.shields.io/github/issues/Sthaynny/ufersa_hub?color=%235965E0">
  <a href="mailto:igorsthaynny@gmail.com">
   <img alt="E-mail" src="https://img.shields.io/badge/-igorsthaynny%40gmail.com-%23525DCB" />
  </a>
</p>

<p align="center">
O <strong>ConectaFERSA</strong> é um hub comunitário para estudantes: avisos, eventos e documentos do campus em um só app — <strong>sem login</strong> para o uso do dia a dia. Feito para quem perde informação em grupos de mensagem e precisa de um lugar confiável na correria da faculdade.
</p>

<p align="center"><em>O que importa no campus, em um só lugar — sem login.</em></p>

<hr />

<div align="center">
  <sub> Made with 💖 by
    <a href="https://github.com/Sthaynny">Igor Sthaynny
  </sub>
</div>

# 📌 Contents

- [📌 Contents](#-contents)
- [:camera: Screenshots](#camera-screenshots)
- [:rocket: Tecnologias](#rocket-tecnologias)
- [:computer: Como rodar](#computer-como-rodar)
- [:bug: Issues](#bug-issues)
- [:sparkles: Contribuição](#sparkles-contribuição)
- [:page_facing_up: Licença](#page_facing_up-licença)

# :camera: Screenshots
<div align="center">
   <img src="https://github.com/user-attachments/assets/02456755-9016-48e5-b7b2-e850632732c6" width="230"/>
   <img src="https://github.com/user-attachments/assets/33803518-9d54-45cb-a8cd-8f83dae2f020" width="230"/>
   <img src="https://github.com/user-attachments/assets/fa12a1c8-2897-4529-bcd9-a35ce0b15d51" width="230"/>
   <img src="https://github.com/user-attachments/assets/6798f95e-1675-435e-b7b6-cd3b2e70f3af" width="230"/>
   <img src="https://github.com/user-attachments/assets/1c562f9a-86f5-4be3-93b5-0f9271242308" width="230"/>
   <img src="https://github.com/user-attachments/assets/475d3a44-3027-4c9c-89a0-60e0083601b8" width="230"/>
</div>
  


# :rocket: Tecnologias
- Flutter (MVVM, GetIt, SOLID)
- Firebase Auth e Cloud Firestore (plano Spark gratuito para laboratório)
- Design System
- Perfil **comunitário** sem login no uso diário — veja [docs/PROPOSITO.md](docs/PROPOSITO.md), [docs/GUIA_UNIVERSITARIO.md](docs/GUIA_UNIVERSITARIO.md) e [docs/ROTEAMENTO.md](docs/ROTEAMENTO.md)

# :computer: Como rodar

```bash
# Clone Repositorio
$ git clone https://github.com/Sthaynny/ufersa_hub.git

# Instale as dependências
$ flutter pub get

# Configure o Firebase (obrigatório para auth e dados)
$ dart pub global activate flutterfire_cli
$ flutterfire configure

# Rode a aplicação
$ flutter run
```

# :bug: Issues

Cria um issue <a href="https://github.com/Sthaynny/ufersa_hub/issues">nova issue</a>, será uma honra poder ajudá-lo a resolver e melhorar ainda mais nosso aplicativo.

# :sparkles: Contribuição

- De um FORK nesse repositório;
- Crie uma nova branch a partir da develop: `git checkout -b my-feature` ou `git flow feature start my-feature`;
- Commit em sua banch: `git commit -m 'feat: my new feature'`;
- Push em sua branch: `git push origin my-feature`.
- Para mais informações acesse o [Guia de contribuição](https://github.com/Sthaynny/ufersa_hub/blob/main/.github/contributing.md)
  
Para ajudar a manter o padrão escolhido, também criamos um arquivo que é chamado antes de cada commit. Este arquivo irá formatar e identificar (se houver) erros no estilo de código do seu código. Para habilitar isso você deve primeiro copiá-lo para a pasta hooks do git. Se você estiver desenvolvendo no macOS, vá até a raiz do projeto e execute o comando abaixo:

```
cp pre-commit .git/hooks/pre-commit
```

Após esta etapa, é necessário dar permissão para que o arquivo seja executado. Basta seguir o seguinte comando:

```
chmod +x .git/hooks/pre-commit
```


# :page_facing_up: Licença

Este projeto está sob a [MIT License](./LICENSE) |
Made with 💖 by [Igor Sthaynny](https://www.linkedin.com/in/igor-sthaynny/).
