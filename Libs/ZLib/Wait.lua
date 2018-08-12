ZLib.Waiter = {
    WaitTable = {};
    WaitFrame = nil;
    Wait = function(self,delay,func,...)
        if(type(delay)~="number" or type(func)~="function") then
            return false;
        end
        if(self.WaitFrame == nil) then
            self.WaitFrame = CreateFrame("Frame","WaitFrame", UIParent);
            self.WaitFrame:SetScript("onUpdate",ZLib.Waiter.Callback);
        end
        tinsert(self.WaitTable,{delay,func,{...}});
        return true;
    end,
    __Callback = function(me,elapse)
        local count = #(ZLib.Waiter.WaitTable);
        local i = 1;
        while(i<=count) do
            local waitRecord = tremove(ZLib.Waiter.WaitTable,i);
            local d = tremove(waitRecord,1);
            local f = tremove(waitRecord,1);
            local p = tremove(waitRecord,1);
            if(d>elapse) then
                tinsert(ZLib.Waiter.WaitTable,i,{d-elapse,f,p});
                i = i + 1;
            else
                count = count - 1;
                f(unpack(p));
            end
        end
    end
}