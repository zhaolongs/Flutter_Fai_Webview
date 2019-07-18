function showImagePreview(url) {


    var idx = 0;
    	for(var i=0;i<imgsrcArr.length;i++){
    		if(imgsrcArr[i]==url){
    			idx= i;
    			break;
    		}
    	}

    	var jsonData = "{\"url\":\""+ url +"\",\"index\":"+idx+",\"urls\":\""+imgsrcArr+"\"}";
controll.showImagePreview(jsonData);
}

 var imgsrcArr = [];
/**
 * JS获取html代码中所有的图片地址
 * @param htmlstr
 * @returns imgsrcArr 数组
 */
function getAllImgSrc(htmlstr) {
    var reg = /<img.+?src=('|")?([^'"]+)('|")?(?:\s+|>)/gim;

    while (tem = reg.exec(htmlstr)) {
        imgsrcArr.push(tem[2]);
    }
    return imgsrcArr;
}
