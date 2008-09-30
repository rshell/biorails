# BiorailsCompounds
#
# Json for home menu 
#
Biorails::Toolbar.add_menu('Inventory','icon-compound','/inventory/compounds',[
    Biorails::Toolbar.menu_item("Compounds", 'icon-compound' ,'/inventory/compounds'),
    Biorails::Toolbar.menu_item("Batches"  , 'icon-batch'    ,'/inventory/batches'),
    Biorails::Toolbar.menu_item("Plates"   , 'icon-batch'    ,'/inventory/plates')
])  
   