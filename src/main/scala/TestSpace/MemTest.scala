package TestSpace
import spinal.core._
object BlockRam extends MemTechnologyKind {
  override def technologyKind: String = "distrubuted"
}
class MemTest extends  Component{
    val wordCount=4096
    val io=new Bundle{
        val writeValid=in Bool()
        val writeAddress=in UInt(log2Up(wordCount) bits)
        val writeData=in Bits(32 bits)
        val readData=out Bits(32 bits)
    }
    val mem = Mem(Bits(32 bits), wordCount).addAttribute("ram_style = \"block\"")
    
    mem.write(
        enable  = io.writeValid,
        address = io.writeAddress,
        data    = io.writeData
    )

    io.readData := mem.readSync(
        enable  = True,
        address = U(0).resized
    )
    
}
