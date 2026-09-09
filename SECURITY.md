# Política de Segurança

## Relatando Vulnerabilidades

Se você descobrir uma vulnerabilidade de segurança, **não abra uma issue pública**. Em vez disso, envie um relatório privado para: **[caiocaladaraujo.dev@gmail.com](mailto:caiocaladaraujo.dev@gmail.com)** com o título "[SEGURANÇA-GEM-PROMPT]".

Por favor, inclua:

- Descrição clara da vulnerabilidade
- Passos para reproduzir
- Possível impacto
- Sugestões de correção (se houver)

Você receberá uma resposta em até 48 horas.

## Versões Suportadas

| Versão     | Status                      | Suporte    |
|------------|-----------------------------|------------|
| Principal  | Suportada (desenvolvimento) | Contínuo   |
| Anteriores | Não suportadas              | -          |

**Nota:** Apenas a versão mais recente (branch `master`) recebe atualizações de segurança. Recomendamos manter-se atualizado com a versão mais recente.

## Melhores Práticas de Segurança

- Mantenha o Flutter SDK e dependências atualizados
- Use `dart pub audit` para verificar vulnerabilidades
- Evite versões "any" no pubspec.yaml
- Revise as permissões das dependências

## Divulgação Coordenada

Após a correção, divulgaremos a vulnerabilidade seguindo a prática padrão de 90 dias.

## Segurança das Dependências

Execute regularmente:

```bash
flutter pub get
```
