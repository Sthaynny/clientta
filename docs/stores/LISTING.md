# Google Play — Sextante

Dados para publicação e revisão interna. Atualizado para a release **1.3.0 (9)**.

## Identificação

| Campo | Valor |
|-------|--------|
| **Nome do app** | Sextante |
| **Package name (applicationId)** | `br.com.sthaynny.university_hub` |
| **Versão** | `1.3.0+9` (`versionName` 1.3.0, `versionCode` 9) |

## Descrição curta (≤ 80 caracteres)

```
Navegue grade, atividades e o dia na faculdade — offline, sem login.
```

_(67 caracteres)_

## Descrição completa (PT-BR)

```
Sextante é um organizador para a rotina na universidade. Tudo fica no seu celular: não é preciso criar conta nem depender de internet para consultar sua grade ou suas tarefas.

O que você pode fazer:
• Ver o painel do dia — aulas e atividades de hoje em um só lugar
• Montar sua grade semanal com horário, sala e disciplina
• Registrar atividades (trabalhos, estudos, provas, presenças) e marcar como concluídas
• Navegar pelo menu com atalhos para grade, atividades e cadastros

Seus dados são armazenados localmente no aparelho (arquivo JSON no dispositivo). O app não envia suas informações para servidores do desenvolvedor.

Sextante é um projeto independente voltado a estudantes que querem simplicidade. Não substitui sistemas oficiais da instituição nem oferece diagnóstico, tratamento ou aconselhamento de saúde.

Hoje o app é gratuito na íntegra; planos Free e Pro são roadmap interno (ver docs/features/README.md na documentação do repositório).
```

## Notas da versão (release 1.3.0)

```
• Retomada do app como organizador offline (grade, atividades e painel do dia)
• Nova identidade Sextante e experiência focada em “o que importa hoje”
• Preparação para publicação na Google Play (versão 1.3.0)
```

## Assets de tela

Prints renomeados em [`prints/`](prints/) — ver [`prints/README.md`](prints/README.md) para mapeamento e ordem sugerida na galeria.

## Build Android

- Versão lida do `pubspec.yaml` via Flutter (`versionCode` / `versionName` em `android/app/build.gradle.kts`).
- Comando típico: `flutter build appbundle`
