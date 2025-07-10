# Cash in Inventory for QBCore

## Português (PT-BR)

### Descrição

Este repositório contém uma modificação do `qb-core` que transforma o dinheiro em espécie (`cash`) em um item físico no inventário, chamado `money`. Isso permite que o dinheiro seja armazenado, dropado ou roubado como qualquer outro item.

### Instruções de Instalação

1. Acesse o arquivo `qb-core/server/player.lua`.
2. Comente as funções originais:
   - `self.Functions.SetMoney`
   - `self.Functions.AddMoney`
   - `self.Functions.RemoveMoney`
   - `self.Functions.GetMoney`
3. Logo abaixo dessas funções comentadas, cole o conteúdo do arquivo `player.lua` disponível neste repositório.
4. Vá até `qb-core/shared/items.lua`.
5. Procure pelo item `moneybag`, copie e cole esse bloco como base.
6. Altere o nome e a descrição para o seu item personalizado de dinheiro, por exemplo: `money`.

### Observações

- Esta alteração é suficiente para tratar o dinheiro como item no inventário.
- Não é necessário modificar scripts como `qb-bank`, pois toda a lógica foi adaptada diretamente dentro do `qb-core`.
- Para tratar dinheiro sujo, você pode utilizar o item `markedbills` já presente em `qb-core/shared/items.lua`.

---

## English (EN)

### Description

This repository contains a modification to `qb-core` that converts player cash into a physical inventory item named `money`. This allows cash to be stored, dropped, or stolen like any other item.

### Installation Instructions

1. Open the `qb-core/server/player.lua` file.
2. Comment out the original functions:
   - `self.Functions.SetMoney`
   - `self.Functions.AddMoney`
   - `self.Functions.RemoveMoney`
   - `self.Functions.GetMoney`
3. Just below those commented functions, paste the `player.lua` content provided in this repository.
4. Go to `qb-core/shared/items.lua`.
5. Search for the `moneybag` item, copy and paste its block as a template.
6. Change the name and description to your custom money item (e.g., `money`).

### Notes

- This change is enough to treat player cash as a physical inventory item.
- Other scripts like `qb-bank` do not need to be modified, since the logic is handled directly inside `qb-core`.
- For dirty money, the `markedbills` item included in `qb-core/shared/items.lua` can be used.
