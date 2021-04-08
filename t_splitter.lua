label = "T-splitter"

about = [[
Splits two paths that are in a T-shape.
]]

-----------------------

function split(model, hat, split_index, stick, stick_reverse)
    curve_1 = { type="curve", closed=false }
    curve_2 = { type="curve", closed=false }
    
    for i = 1, split_index do
        curve_1[#curve_1 + 1] = { type="segment", hat[i][1], hat[i][2]}
    end
    for i = #hat, split_index + 1, -1 do
        curve_2[#curve_2 + 1] = { type="segment", hat[i][2], hat[i][1]}
    end
   

    ---if stick_reverse then
    ---    for i = #stick, 1, -1 do
    ---        curve_1[#curve_1 + 1] = { type="segment", stick[i][2], stick[i][1]}
    ---        curve_2[#curve_2 + 1] = { type="segment", stick[i][2], stick[i][1]}
    ---    end
    ---else
    ---    for i = 1, #stick do
    ---        curve_1[#curve_1 + 1] = { type="segment", stick[i][1], stick[i][2]}
    ---        curve_2[#curve_2 + 1] = { type="segment", stick[i][1], stick[i][2]}
    ---    end
    ---end
    
    path_1 = ipe.Path(model.attributes, {curve_1})
    path_2 = ipe.Path(model.attributes, {curve_2})
    
    
    model:creation("path_1", path_1)
    model:creation("path_2", path_2)
    
end

function run(model)
   
    local page = model:page()
    local prim = page:primarySelection()
    local obj = page[prim]
   
    local one_found = false
    local two_found = false
   
    local path_a
    local path_b
   
    for i = 1,#page do
        if page:select(i) ~= ENotSelected then
            if page[i]:type() == "path" then
                if not one_found then
                    path_a = page[i]
                    one_found = true
                else
                    path_b = page[i]
                    two_found = true
                    break
                end
            end
        end
    end
    
    if not two_found then
        model:warning("Please select two paths!")
        return
    end
   
    t_a = path_a:shape()
    
    t_b = path_b:shape()
    
    
    for i=1,#t_a do
        for j=1,#t_a[i] do
            for k=1,#t_a[i][j] do
                if t_a[i][j][k] == t_b[#t_b][#t_b[#t_b]][2] then
                    split(model, t_a[i], j, t_b[#t_b], true)
                    return
                elseif t_a[i][j][k] == t_b[1][1][1] then
                    split(model, t_a[i], j, t_b[1], false)
                    return
                end
			end
        end
	end
    
    for i=1,#t_b do
        for j=1,#t_b[i] do
            for k=1,#t_b[i][j] do
                if t_b[i][j][k] == t_a[#t_a][#t_a[#t_a]][2] then
                    split(model, t_b[i], j, t_a[#t_a], true)
                    return
                elseif t_b[i][j][k] == t_a[1][1][1] then
                    split(model, t_b[i], j, t_a[1], false)
                    return
                end
			end
        end
	end
    
    
end


