label = "Involute"

about = [[
Involute drawer ipelet.
]]

methods = {
  { label = "Clockwise", clockwise=true },
  { label = "Counter-clockwise", clockwise=false },
}


-----------------------

function isLeft(a, b, m)
    return (b.x - a.x)*(m.y - a.y) - (b.y - a.y)*(m.x - a.x) >= 0
end

function isRight(a, b, m)
    return (b.x - a.x)*(m.y - a.y) - (b.y - a.y)*(m.x - a.x) <= 0
end

function generateNextPoint(model, point, path, step, clockwise)
    
    local most_extreme
    
    -- Find the point that lies on the left of the convex hull
    for i=1, #path do
        extreme = true
        
        if point ~= path[i] then
        
            for j=1, #path do
                if clockwise then
                    if not isRight(point, path[i], path[j]) then
                        extreme = false
                        break
                    end
                else
                    if not isLeft(point, path[i], path[j]) then
                        extreme = false
                        break
                    end
                end
            end
            if extreme then
                -- Asuming that there is only one point on the edge, fix later
                most_extreme = path[i]
                break
            end
        end
    end
    
    tangent = most_extreme - point
    direction = tangent:orthogonal():normalized()
    
    if not clockwise then
        direction = direction:orthogonal():orthogonal()
    end
    
    nextPoint = point + (step * direction)
    
    return nextPoint
    
end

function run(model, num)
    c = 200
   
    local page = model:page()
    local prim = page:primarySelection()
    local obj = page[prim]
    
    local clockwise = methods[num].clockwise
   
   
    local point
    local path
   
    for i = 1,#page do
        if page:select(i) ~= ENotSelected then
            if page[i]:type() == "reference" then
                point = page[i]:matrix()*page[i]:position()
            elseif page[i]:type() == "path" then
                path = page[i]
            end
        end
    end
   
    t = path:shape()
   
    points_t = {}
    
    for i=1,#t do
        for j=1,#t[i] do
            for k=1,#t[i][j] do
                if points_t[#points_t] ~= t[i][j][k] then 
                    points_t[#points_t + 1] = t[i][j][k]
                end
			end
        end
	end
    
    step = 1
    
    curve = { type="curve", closed=false }
    
    next_point = generateNextPoint(model, point, points_t, step, clockwise)
     
    curve[#curve + 1] = { type="segment", point, next_point}
    
    local start_angle = (next_point - point):angle()
    
    point = nextPoint
    
    angle = start_angle
    
    angle_difference = 0
    
    while angle_difference < 1.5 * math.pi and c >= 0 do
        next_point = generateNextPoint(model, point, points_t, step, clockwise)
         
        curve[#curve + 1] = { type="segment", point, next_point}
        
        angle = (next_point - point):angle()
        if clockwise then
            angle_difference = start_angle - angle
        else
            angle_difference = angle - start_angle
        end
        
        if angle_difference < 0 then angle_difference = angle_difference + 2 * math.pi end
        
        point = nextPoint
        
        c = c - 1
    end
    involute = ipe.Path(model.attributes, {curve})
    
    model:creation("Create log spiral leaf", involute)
    
    
end


