resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

version '0.1'

this_is_a_map 'yes'

files {
    'stream/CarData/vehicles.meta',
    'stream/CarData/carvariations.meta',
    'stream/CarData/handling.meta',
    'stream/CarData/dlctext.meta',
    'stream/CarData/carcols.meta'
}

data_file 'CARCOL_FILE' 'stream/CarData/carcol.meta'
data_file 'VEHICLE_VARIATION_FILE' 'stream/CarData/carvariations.meta'
data_file 'DLCTEXT_FILE' 'stream/CarData/dlctext.meta'
data_file 'HANDLING_FILE' 'stream/CarData/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'stream/CarData/vehicles.meta'

