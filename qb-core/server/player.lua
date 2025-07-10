    function self.Functions.SetMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return false end

        local oldAmount = self.PlayerData.money[moneytype] or 0

        if moneytype == 'money' or moneytype == 'cash' then
            local item = self.Functions.GetItemByName('money')
            if item then
                self.Functions.RemoveItem('money', item.amount)
            end
            self.Functions.AddItem('money', amount)
        end

        self.PlayerData.money[moneytype] = amount

        if not self.Offline then
            self.Functions.UpdatePlayerData()

            TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'SetMoney', 'green', ([
                '**%s (Citizenid: %s | Id: %s)**\n> $%s (%s) Definido\n> Novo saldo %s: %s\n> Motivo: %s'
            ]):format(
                GetPlayerName(self.PlayerData.source),
                self.PlayerData.citizenid,
                self.PlayerData.source,
                amount,
                moneytype,
                moneytype,
                self.PlayerData.money[moneytype],
                reason
            ), false)

            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, math.abs(amount - oldAmount), false)
            TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'set', reason)
            TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'set', reason)
        end

        return true
    end

    function self.Functions.AddMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return false end

        local newAmount = 0

        if moneytype == 'money' or moneytype == 'cash' then
            local item = self.Functions.GetItemByName('money')
            local currentAmount = item and item.amount or 0
            self.Functions.RemoveItem('money', currentAmount)
            self.Functions.AddItem('money', currentAmount + amount)
            newAmount = currentAmount + amount
        else
            if not self.PlayerData.money[moneytype] then return false end
            newAmount = self.PlayerData.money[moneytype] + amount
        end

        self.PlayerData.money[moneytype] = newAmount

        if not self.Offline then
            self.Functions.UpdatePlayerData()

            local logMsg = ('**%s (Citizenid: %s | Id: %s)**\n' ..
                            '> $%s (%s) Adicionado\n' ..
                            '> Novo saldo %s: %s\n' ..
                            '> Motivo: %s'):format(
                GetPlayerName(self.PlayerData.source),
                self.PlayerData.citizenid,
                self.PlayerData.source,
                amount,
                moneytype,
                moneytype,
                newAmount,
                reason
            )

            TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'Add Money', 'lightgreen', logMsg, amount > 100000)

            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, false)
            TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'add', reason)
            TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'add', reason)
        end

        return true
    end

    function self.Functions.RemoveMoney(moneytype, amount, reason)
        reason = reason or 'unknown'
        moneytype = moneytype:lower()
        amount = tonumber(amount)
        if amount < 0 then return false end

        local newAmount = 0

        if moneytype == 'money' or moneytype == 'cash' then
            local item = self.Functions.GetItemByName('money')
            local currentAmount = item and item.amount or 0
            if currentAmount < amount then return false end
            self.Functions.RemoveItem('money', amount)
            newAmount = currentAmount - amount
        else
            if not self.PlayerData.money[moneytype] then return false end

            for _, mtype in pairs(QBCore.Config.Money.DontAllowMinus) do
                if mtype == moneytype and (self.PlayerData.money[moneytype] - amount) < 0 then
                    return false
                end
            end

            if (self.PlayerData.money[moneytype] - amount) < QBCore.Config.Money.MinusLimit then
                return false
            end

            newAmount = self.PlayerData.money[moneytype] - amount
        end

        self.PlayerData.money[moneytype] = newAmount

        if not self.Offline then
            self.Functions.UpdatePlayerData()

            local logMsg = ('**%s (Citizenid: %s | Id: %s)**\n' ..
                            '> $%s (%s) Removido\n' ..
                            '> Novo saldo %s: %s\n' ..
                            '> Motivo: %s'):format(
                GetPlayerName(self.PlayerData.source),
                self.PlayerData.citizenid,
                self.PlayerData.source,
                amount,
                moneytype,
                moneytype,
                newAmount,
                reason
            )

            TriggerEvent('qb-log:server:CreateLog', 'playermoney', 'Remove Money', 'red', logMsg, amount > 100000)

            TriggerClientEvent('hud:client:OnMoneyChange', self.PlayerData.source, moneytype, amount, true)
            if moneytype == 'bank' then
                TriggerClientEvent('qb-phone:client:RemoveBankMoney', self.PlayerData.source, amount)
            end
            TriggerClientEvent('QBCore:Client:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'remove', reason)
            TriggerEvent('QBCore:Server:OnMoneyChange', self.PlayerData.source, moneytype, amount, 'remove', reason)
        end

        return true
    end

    function self.Functions.GetMoney(moneytype)
        if not moneytype then return false end
        moneytype = moneytype:lower()
        if moneytype == 'money' or moneytype == 'cash' then
            local item = self.Functions.GetItemByName('money')
            return item and item.amount or 0
        end
        return self.PlayerData.money[moneytype] or 0
    end
