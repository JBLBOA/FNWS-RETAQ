package objects;

import haxe.Json;
import haxe.format.JsonParser;

typedef BanderasData = {
    var banderas:Array<Int>;
};

class BanderasParser
{
    public var banderas:Array<Int> = [];
    var wea:BanderasData;

    public function new(jsonString:String = '')
    {
        wea = Json.parse(jsonString);
        banderas = wea.banderas.copy();
    }
}