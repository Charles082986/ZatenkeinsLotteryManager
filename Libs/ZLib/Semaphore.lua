ZLib.Semaphore = {
    new = function(self,count,callback,...)
        return {
            Count = count,
            Itterations = 0;
            __callback = callback;
            args = {...},
            Itterate = self.__Itterate;
            AddCount = self.__AddCount;
        };
    end,
    __Itterate = function(self,value)
        if not ZLib:IsNumberValid(value) then value = 1; end
        self.Itterations = self.Itterations + value;
        if self.Itterations >= self.Count then
            self:__callback(unpack(self.args));
        end
    end,
    __AddCount = function(self,value)
        if not ZLib:IsNumberValid(value) then value = 1; end
        self.Count = self.Count + value;
    end
}