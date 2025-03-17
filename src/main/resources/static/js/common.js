function checkNotNull(str){
    if(str == null || str == "" || str == undefined ||str.length < 1){
        return false;
    }
    return true;
}

function zuiMsg(msg){
    // 出错提示
    $.zui.messager.show(msg, {placement: 'top', type: 'danger'}).show();
    return
}