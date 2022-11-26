package utils

case class TopConfig(){
//layernorm config============================================================
    val CHANNEL_NUMS=384//通道数
    val TOKEN_NUMS=197//token 数
    val PIPELINE=8//8并行度

    val IN_DATA_WIDTH=64//输入数据位宽64bit

}