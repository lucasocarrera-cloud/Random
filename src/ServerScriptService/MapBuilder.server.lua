-- Static world: studded ground, central concrete shop circle, 6 plot lots (3x2).
-- Lots are named Lot1..Lot6, each with a "Beam" holding a BillboardGui with
-- "Title"/"Sub" TextLabels that PlotManager.setLotSign updates.
local WS = workspace
local Lighting = game:GetService("Lighting")

local function P(parent, name, size, pos, color, opts)
	opts = opts or {}
	local p = Instance.new("Part")
	p.Name=name; p.Anchored=true; p.Size=size; p.Position=pos; p.Color=color
	p.Material = opts.material or Enum.Material.SmoothPlastic
	p.TopSurface = opts.studs and Enum.SurfaceType.Studs or Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Transparency = opts.transparency or 0
	if opts.cframe then p.CFrame = opts.cframe end
	p.Parent = parent
	return p
end

local old = WS:FindFirstChild("WorldMap"); if old then old:Destroy() end
for _,n in ipairs({"Baseplate","WhalesPlaceholder","RedBlock"}) do
	local o = WS:FindFirstChild(n); if o then o:Destroy() end
end
local map = Instance.new("Folder"); map.Name="WorldMap"; map.Parent=WS

local GRASS=Color3.fromRGB(98,200,104) local CONC=Color3.fromRGB(176,178,184)
local CONC2=Color3.fromRGB(140,142,150) local STONE=Color3.fromRGB(196,198,205)
local GREEN=Color3.fromRGB(120,205,130) local BRICK=Color3.fromRGB(172,112,72)
local FENCE=Color3.fromRGB(240,243,248) local PATH=Color3.fromRGB(196,205,214)

P(map,"Ground",Vector3.new(280,2,300),Vector3.new(0,-1,0),GRASS,{studs=true})

-- central concrete circle (shops spawn here; World.lua Stands are at Z=0)
P(map,"CircleRing",Vector3.new(1,134,134),Vector3.new(0,0.45,0),CONC2,
	{material=Enum.Material.Concrete,cframe=CFrame.new(0,0.45,0)*CFrame.Angles(0,0,math.rad(90))})
P(map,"Circle",Vector3.new(1.2,124,124),Vector3.new(0,0.55,0),CONC,
	{material=Enum.Material.Concrete,cframe=CFrame.new(0,0.55,0)*CFrame.Angles(0,0,math.rad(90))})

-- 3x2 grid. f = facing toward the circle. MUST match PLOT_GRID in PlotManager.
local bases = {
	{p=Vector3.new(-78,0,-104),f=1},{p=Vector3.new(0,0,-104),f=1},{p=Vector3.new(78,0,-104),f=1},
	{p=Vector3.new(-78,0,104),f=-1},{p=Vector3.new(0,0,104),f=-1},{p=Vector3.new(78,0,104),f=-1},
}
local accents={Color3.fromRGB(80,140,255),Color3.fromRGB(255,95,95),Color3.fromRGB(85,205,115),
	Color3.fromRGB(195,95,235),Color3.fromRGB(255,165,45),Color3.fromRGB(60,205,222)}

local lots=Instance.new("Folder"); lots.Name="Lots"; lots.Parent=map
for i,b in ipairs(bases) do
	local base,f=b.p,b.f
	local frontZ=base.Z+f*20
	local backZ=base.Z-f*20
	local lot=Instance.new("Model"); lot.Name="Lot"..i; lot.Parent=lots

	P(lot,"Foundation",Vector3.new(56,1,40),base+Vector3.new(0,0.5,0),STONE,{studs=true})
	P(lot,"EmptyPad",Vector3.new(40,0.6,24),base+Vector3.new(0,1.1,0),GREEN,{studs=true,transparency=0.15})
	P(lot,"FenceBack",Vector3.new(56,4,1.5),Vector3.new(base.X,2.5,backZ),FENCE,{studs=true})
	P(lot,"FenceL",Vector3.new(1.5,4,40),base+Vector3.new(-28,2.5,0),FENCE,{studs=true})
	P(lot,"FenceR",Vector3.new(1.5,4,40),base+Vector3.new(28,2.5,0),FENCE,{studs=true})
	P(lot,"FenceFL",Vector3.new(20,4,1.5),Vector3.new(base.X-18,2.5,frontZ),FENCE,{studs=true})
	P(lot,"FenceFR",Vector3.new(20,4,1.5),Vector3.new(base.X+18,2.5,frontZ),FENCE,{studs=true})
	P(lot,"PillarL",Vector3.new(3,12,3),Vector3.new(base.X-9,6,frontZ),BRICK,{studs=true})
	P(lot,"PillarR",Vector3.new(3,12,3),Vector3.new(base.X+9,6,frontZ),BRICK,{studs=true})
	local beam=P(lot,"Beam",Vector3.new(24,4,3),Vector3.new(base.X,13.5,frontZ),accents[i],{studs=true})

	local bb=Instance.new("BillboardGui")
	bb.Size=UDim2.new(0,200,0,70); bb.StudsOffset=Vector3.new(0,2.8,0)
	bb.AlwaysOnTop=true; bb.Adornee=beam; bb.Parent=beam
	local title=Instance.new("TextLabel"); title.Name="Title"
	title.Size=UDim2.new(1,0,0.6,0); title.BackgroundTransparency=1
	title.Text="Plot "..i; title.TextColor3=Color3.new(1,1,1)
	title.TextStrokeTransparency=0; title.TextScaled=true; title.Font=Enum.Font.FredokaOne; title.Parent=bb
	local sub=Instance.new("TextLabel"); sub.Name="Sub"
	sub.Position=UDim2.new(0,0,0.6,0); sub.Size=UDim2.new(1,0,0.4,0)
	sub.BackgroundTransparency=1; sub.Text="Empty"
	sub.TextColor3=Color3.fromRGB(230,230,235); sub.TextStrokeTransparency=0.3
	sub.TextScaled=true; sub.Font=Enum.Font.GothamBold; sub.Parent=bb

	P(map,"Path"..i,Vector3.new(8,1,40),Vector3.new(base.X,0.45,base.Z+f*32),PATH,{studs=true})
end

local spawn=WS:FindFirstChildWhichIsA("SpawnLocation") or Instance.new("SpawnLocation")
spawn.Name="SpawnLocation"; spawn.Size=Vector3.new(12,1,12); spawn.Position=Vector3.new(0,1.4,0)
spawn.Anchored=true; spawn.Neutral=true; spawn.Color=Color3.fromRGB(255,220,70)
spawn.Material=Enum.Material.SmoothPlastic; spawn.TopSurface=Enum.SurfaceType.Studs; spawn.Parent=WS

local function tree(x,z,s) s=s or 1; local m=Instance.new("Model");m.Name="Tree";m.Parent=map
	local th=11*s
	P(m,"Trunk",Vector3.new(3*s,th,3*s),Vector3.new(x,th/2,z),Color3.fromRGB(124,84,52),{studs=true})
	P(m,"Leaf1",Vector3.new(11*s,7*s,11*s),Vector3.new(x,th+3*s,z),Color3.fromRGB(86,190,96),{studs=true})
	P(m,"Leaf2",Vector3.new(7*s,6*s,7*s),Vector3.new(x,th+8*s,z),Color3.fromRGB(64,166,78),{studs=true})
end
local function lamp(x,z) local m=Instance.new("Model");m.Name="Lamp";m.Parent=map
	P(m,"Post",Vector3.new(1.2,11,1.2),Vector3.new(x,5.5,z),Color3.fromRGB(70,75,85),{studs=true})
	local bl=P(m,"Bulb",Vector3.new(2.2,2.2,2.2),Vector3.new(x,11.5,z),Color3.fromRGB(255,238,150)); bl.Material=Enum.Material.Neon
	local pl=Instance.new("PointLight");pl.Range=20;pl.Brightness=1.3;pl.Color=Color3.fromRGB(255,240,180);pl.Parent=bl
end
for _,c in ipairs({{-118,-128},{118,-128},{-118,128},{118,128}}) do tree(c[1],c[2],1.2) end
for _,c in ipairs({{-66,-66},{66,-66},{-66,66},{66,66}}) do lamp(c[1],c[2]) end

P(map,"WallS",Vector3.new(284,6,2),Vector3.new(0,3,-150),FENCE,{studs=true})
P(map,"WallN",Vector3.new(284,6,2),Vector3.new(0,3,150),FENCE,{studs=true})
P(map,"WallW",Vector3.new(2,6,302),Vector3.new(-140,3,0),FENCE,{studs=true})
P(map,"WallE",Vector3.new(2,6,302),Vector3.new(140,3,0),FENCE,{studs=true})

pcall(function() Lighting.Technology=Enum.Technology.Future end)
Lighting.Brightness=2.2; Lighting.ClockTime=14
Lighting.OutdoorAmbient=Color3.fromRGB(150,150,160)
Lighting.Ambient=Color3.fromRGB(90,90,100); Lighting.GlobalShadows=true
local atmo=Lighting:FindFirstChildWhichIsA("Atmosphere") or Instance.new("Atmosphere")
atmo.Density=0.32; atmo.Haze=1.2; atmo.Color=Color3.fromRGB(220,235,255)
atmo.Decay=Color3.fromRGB(160,190,230); atmo.Parent=Lighting
