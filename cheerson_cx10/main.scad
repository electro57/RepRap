module falcon()
{
    linear_extrude(height=1, $fn=128) {
        import(file="main.dxf", layer="millennium_falcon");
    }
}


module tie()
{
}


falcon();
