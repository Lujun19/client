--[[
    位操作
]]
--bit={data32={}}
bit32 = bit32 or {}
function bit32.init32()
    bit32.data32 = {}
    for i=1,32 do
        bit32.data32[i]=2^(32-i)
    end
end
bit32.init32()

function bit32:d2b(arg)  --bit32:d2b
    local   tr={}
    for i=1,32 do
        if arg >= self.data32[i] then
        tr[i]=1
        arg=arg-self.data32[i]
        else
        tr[i]=0
        end
    end
    return   tr
end

function bit32:b2d(arg)  --bit32:b2d
    local   nr=0
    for i=1,32 do
        if arg[i] ==1 then
        nr=nr+2^(32-i)
        end
    end
    return  nr
end

function bit32:_xor(a,b)  --bit32:xor
    local   op1=self:d2b(a)
    local   op2=self:d2b(b)
    local   r={}

    for i=1,32 do
        if op1[i]==op2[i] then
            r[i]=0
        else
            r[i]=1
        end
    end
    return  self:b2d(r)
end

function bit32:_and(a,b)  --bit32:_and
    local   op1=self:d2b(a)
    local   op2=self:d2b(b)
    local   r={}

    for i=1,32 do
        if op1[i]==1 and op2[i]==1  then
            r[i]=1
        else
            r[i]=0
        end
    end
    return  self:b2d(r)

end

function bit32:_or(a,b)  --bit32:_or
    local   op1=self:d2b(a)
    local   op2=self:d2b(b)
    local   r={}

    for i=1,32 do
        if  op1[i]==1 or   op2[i]==1   then
            r[i]=1
        else
            r[i]=0
        end
    end
    return  self:b2d(r)
end

function bit32:_not(a)  --bit32:_not
    local op1=self:d2b(a)
    local r={}

    for i=1,32 do
        if  op1[i]==1   then
            r[i]=0
        else
            r[i]=1
        end
    end
    return  self:b2d(r)
end

function bit32:_rshift(a,n)  --bit32:_rshift
    local op1=self:d2b(a)
    local r=self:d2b(0)

    if n < 32 and n > 0 then
        for i=1,n do
            for i=31,1,-1 do
                op1[i+1]=op1[i]
            end
            op1[1]=0
        end
    r=op1
    end
    return  self:b2d(r)
end

function bit32:_lshift(a,n)   --bit32:_lshift
    local op1=self:d2b(a)
    local r=self:d2b(0)

    if n < 32 and n > 0 then
        for i=1,n   do
            for i=1,31 do
                op1[i]=op1[i+1]
            end
            op1[32]=0
        end
    r=op1
    end
    return  self:b2d(r)
end


function bit32:print(ta)
    local   sr=""
    for i=1,32 do
        sr=sr..ta[i]
    end
    print(sr)
end
