ZLib.Debug = {
    IsDev = false,
    Print = function(self,message)
        if self.IsDev then
            print("ZLib Debug: " .. message);
        end
    end
}