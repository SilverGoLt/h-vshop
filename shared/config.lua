Config = {}

-- Plate configuration
Config.PlateLetters  = 3
Config.PlateNumbers  = 3
Config.PlateUseSpace = true
Config.Payment = 'bank'

-- This table is used to configure different shops!
Config.Shops = {
    {
        name = 'Premium Motors Dealership',
        description = 'At our dealership you can find only premium quality vehicles that are brand new and not used!',
        pos = vec3(-33.942856, -1102.008789, 26.415405), -- Vec3(x, y, z)
        preview = vec3(-43.279121, -1099.938477, 26.415405), previewHeading = 68.031494, -- Vec3(x, y, z)
        category = 'sports', -- Vehicle Category
        blip = { -- Blip Settings
            color = 3,
            sprite = 355,
        },
        delivery = { -- Vehicle spawnpoint
            pos = vec3(-27.863733, -1082.571411, 26.600708),
            heading = 68.031494, -- Vehicle heading
        }
    },
    {
        name = 'Easy Boats',
        description = 'At our dealership you can find only boats that are brand new and not used!',
        pos = vec3(-898.958252, -1333.107666, 1.595581), -- Vec3(x, y, z)
        preview = vec3(-891.520874, -1349.736206, -0.176929), previewHeading = -201.259842, -- Vec3(x, y, z)
        category = 'boats', -- Vehicle Category
        cameraDistance = 10.0,
        blip = { -- Blip Settings
            color = 3,
            sprite = 355,
        },
        delivery = { -- Vehicle spawnpoint
            pos = vec3(-897.191223, -1350.026367, 1.595581),
            heading = 5.669291, -- Vehicle heading
        }
    },
    {
        name = 'Big Truck Dealership',
        description = 'At our dealership you can find only big trucks that are brand new and not used!',
        pos = vec3(1240.668091, -3239.010986, 6.027100), -- Vec3(x, y, z)
        preview = vec3(1252.061523, -3239.063721, 5.791260), previewHeading = 8.503937, -- Vec3(x, y, z)
        cameraDistance = 12.0, -- Camera Distance
        category = 'trucks', -- Vehicle Category
        blip = { -- Blip Settings
            color = 3,
            sprite = 355,
        },
        delivery = { -- Vehicle spawnpoint
            pos = vec3(1243.529663, -3222.593506, 5.791260),
            heading = 85.039368, -- Vehicle heading
        }
    }
}

Config.Translation = {
    purchase = "Purchase",
    currency = "$"
}

-- This table is used for your vehicle shops!
Config.Vehicles = {
    {
        name = 'Sultan RS',
        model = 'sultanrs',
        price = 100000,
        category = 'sports',
    },
    {
        name = 'Sultan',
        model = 'sultan',
        price = 100000,
        category = 'sports',
    },
    {
        name = 'Qucik BOi',
        model = 'speeder',
        price = 50000,
        category = 'boats'
    },
    {
        name = 'Phantom',
        model = 'phantom',
        price = 250000,
        category = 'trucks'
    }
}