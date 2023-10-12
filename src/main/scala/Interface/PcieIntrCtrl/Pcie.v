///////////////////////////////////////////////////////////////////////////////
// ?2007-2008 Xilinx, Inc. All Rights Reserved.
// Confidential and proprietary information of Xilinx, Inc.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____ 
//  /   /\/   / 
// /___/  \  /   Vendor: Xilinx 
// \   \   \/    Version: 1.0
//  \   \        Filename:  user_intr.v
//  /   /        Date Last Modified: Oct. 5th, 2007 
// /___/   /\    Date Created: Oct. 5th, 2007
// \   \  /  \ 
//  \___\/\___\ 
//
// Device: All
// Purpose: User Interrupt Generate.   
//
// Reference:  
// Revision History:
//   Rev 1.0 - First created, ZhangMengjie, Apr. 1 2008.
///////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 100ps

//2023.10.7，张凯的pcie intr

module pcie_intr	
	# (
		parameter	tDLY		= 0				    // Simulation delay
	)
	
	(
		// AXI4-Lite                                             
	    input                   m_axi_aclk,         // Global Clock Signal
	    input                   m_axi_aresetn,      // Global Reset Signal. This Signal is Active LOW
		// AXI Master Write Address Channel
		output      [31:0]      m_axil_awaddr,      // Write address                
        output      [2:0]       m_axil_awprot,      // Write channel Protection type
        output                  m_axil_awvalid,     // Write address valid          
        input                   m_axil_awready,     // Write address ready          
        // AXI Master Write Data Channel                                             
        output      [31:0]      m_axil_wdata,       // Write data                   
        output      [3:0]       m_axil_wstrb,       // Write strobes                
        output                  m_axil_wvalid,      // Write valid                  
        input                   m_axil_wready,      // Write ready                  
        // AXI Master Write Response Channel                                         
        input                   m_axil_bvalid,      // Write response               
        input       [1:0]       m_axil_bresp,       // Write response valid         
        output                  m_axil_bready,      // Response ready               
        // AXI Master Read Address Channel                                           
        output      [31:0]      m_axil_araddr,      // Read address                 
        output      [2:0]       m_axil_arprot,      // Protection type              
        output                  m_axil_arvalid,     // Read address valid           
        input                   m_axil_arready,     // Read address ready           
        // AXI Master Read Data Channel                                              
        input       [31:0]      m_axil_rdata,       // Read data                    
        input       [1:0]       m_axil_rresp,       // Read response                
        input                   m_axil_rvalid,      // Read valid                   
        output                  m_axil_rready,      // Read ready                   

		// User Interrupt Interface
		input       [15:0]      usr_clk,
		input       [15:0]      usr_intr_in,           // user interrupt request, rising-edge active
		output      [15:0]      usr_intr_ena,       // user interrupt enable                    
		
		// Interrupt Interface
		input                   pcie_lnk_up,        // Output Active-High Identifies that the PCI Express core is linked up with a host device
		input                   msi_enable,         // Indicates when MSI is enabled
		output      [15:0]      usr_irq_req,        // Assert to generate an interrupt
		input       [15:0]      usr_irq_ack         // Indicates that the interrupt has been sent on PCIe
);




//---------------------------------------------------------------------
// registers
//---------------------------------------------------------------------
 (* MARK_DEBUG="true" *)reg     [3:0]       intr_gen[15:0];
 (* MARK_DEBUG="true" *)reg     [3:0]       intr_cnt[15:0];
 (* MARK_DEBUG="true" *)reg     [2:0]       pcie_reg_state;

// AXI Slave Read Address Channel                                           
 (* MARK_DEBUG="true" *)reg     [31:0]      m_axil_araddr_r;    // Read address            
 (* MARK_DEBUG="true" *)reg                 m_axil_arvalid_r;   // Read address valid
        
// User Interrupt Interface
 (* MARK_DEBUG="true" *)reg     [15:0]      usr_intr_r;         // user interrupt request, rising-edge active
 (* MARK_DEBUG="true" *)reg     [15:0]      usr_intr_r2;        // user interrupt request, rising-edge active
 (* MARK_DEBUG="true" *)reg     [15:0]      usr_intr_r3;        // user interrupt request, rising-edge active

// Interrupt Interface
 (* MARK_DEBUG="true" *)reg                 pcie_lnk_up_r;      // Output Active-High Identifies that the PCI Express core is linked up with a host device
 (* MARK_DEBUG="true" *)reg                 msi_enable_r;       // Indicates when MSI is enabled
 (* MARK_DEBUG="true" *)reg     [15:0]      usr_irq_req_r;      // Assert to generate an interrupt
 (* MARK_DEBUG="true" *)reg                 pcie_lnk_up_r2;     // Output Active-High Identifies that the PCI Express core is linked up with a host device
 (* MARK_DEBUG="true" *)reg                 msi_enable_r2;      // Indicates when MSI is enabled                


// fifo interface
 (* MARK_DEBUG="true" *)reg		[15:0]      fifo_wrreq;
 (* MARK_DEBUG="true" *)reg     [15:0]      fifo_rdreq;

 (* MARK_DEBUG="true" *)reg     [15:0]      pcie2dma_addr;
 (* MARK_DEBUG="true" *)reg     [15:0]      usr_intr_en_mask;
 (* MARK_DEBUG="true" *)wire    [15:0]      usr_intr;

//---------------------------------------------------------------------
// wires
//---------------------------------------------------------------------
 (* MARK_DEBUG="true" *)wire    [15:0]      fifo_empty;

//---------------------------------------------------------------------
// PCIE_REG_FSM state variable assignments (sequential coded) 
//---------------------------------------------------------------------
localparam 	pcie_reg_idle	    = 3'b000;
localparam 	pcie_reg_rd_pre     = 3'b001;
localparam 	pcie_reg_rd         = 3'b010;
localparam 	pcie_reg_rd_ack     = 3'b011;
localparam	pcie_reg_rd_dat	    = 3'b100;
// AXI Slave Write Address Channel
assign  m_axil_awaddr   = 0;              
assign  m_axil_awprot   = 0;
assign  m_axil_awvalid  = 1'b0;          
// AXI Slave Write Data Channel                                             
assign  m_axil_wdata    = 0;                  
assign  m_axil_wstrb    = 0;                
assign  m_axil_wvalid   = 1'b0;                  
// AXI Slave Write Response Channel         
assign  m_axil_bready   = 1'b1;               
// AXI Slave Read Address Channel                                           
assign  m_axil_araddr   = m_axil_araddr_r;                
assign  m_axil_arprot   = 0;              
assign  m_axil_arvalid  = m_axil_arvalid_r;           
// AXI Slave Read Data Channel                  
assign  m_axil_rready   = 1'b1;
        
assign  usr_intr_ena    = usr_intr_en_mask;

// Interrupt Interface
assign  usr_irq_req     = usr_irq_req_r;
//---------------------------------------------------------------------
//
//---------------------------------------------------------------------

//---------------------------------------------------------------------
// Input Register
//---------------------------------------------------------------------
always@(posedge m_axi_aclk)
begin
    if (!m_axi_aresetn)
    begin
        usr_intr_r <= #tDLY 0;
        usr_intr_r2 <= #tDLY 0;
        usr_intr_r3 <= #tDLY 0;
        
        pcie_lnk_up_r <= #tDLY 1'b0;
        pcie_lnk_up_r2 <= #tDLY 1'b0;
        msi_enable_r <= #tDLY 1'b0;
        msi_enable_r2 <= #tDLY 1'b0;
    end
    else
    begin
        usr_intr_r <= #tDLY usr_intr;
        usr_intr_r2 <= #tDLY usr_intr_r;
        usr_intr_r3 <= #tDLY usr_intr_r2;
        
        pcie_lnk_up_r <= #tDLY pcie_lnk_up;
        pcie_lnk_up_r2 <= #tDLY pcie_lnk_up_r;
        msi_enable_r <= #tDLY msi_enable;
        msi_enable_r2 <= #tDLY msi_enable_r;
    end
end


generate
begin
    genvar	i;
    for (i = 0; i <= 15; i = i + 1)
    begin : gen_intr_fifo_gen
        // INTR Request
        always@(posedge usr_clk[i])begin
            if(usr_intr_in[i])
                intr_cnt[i] = 4'd0;
            else if(!(intr_cnt[i][3]))
                intr_cnt[i] = intr_cnt[i] + 4'd1;
        end
        assign usr_intr[i] = !(intr_cnt[i][3]);
        
        always@(posedge m_axi_aclk)
        begin
            if (!m_axi_aresetn)
            begin
                fifo_wrreq[i] <= #tDLY 0;
            end
            else
            begin
                if ((!usr_intr_r3[i]) && usr_intr_r2[i])//上升沿
                begin
                    fifo_wrreq[i] <= #tDLY 1'b1;
                end
                else
                begin
                    fifo_wrreq[i] <= #tDLY 1'b0;
                end
            end
        end
        
        // INTR FIFO
        sync_fifo_show_ahead_dist 
        	# (	
        		.tDLY				(tDLY),
        		
        		.FIFO_DATA_WIDTH	(1),
        		.FIFO_ADDR_WIDTH	(5),
        		
        		.PROG_FULL_THR		(0),
        		.PROG_EMPTY_THR		(0)
        	)
        	
        	intr_fifo_inst
        	(
        		// Main Clock and Reset#
        		.clock				(m_axi_aclk),
        		.reset_n			(m_axi_aresetn),
        		
        		// Sync FIFO Interface
        		.wrreq				(fifo_wrreq[i]),
        		.data				(1'b0),
        		.rdreq				(fifo_rdreq[i]),
        		.q					(),
        		.prog_full			(),
        		.prog_empty			(),
        		.full				(),
        		.empty				(fifo_empty[i]),
        		.usedw				()
        	);
        
        // INTR Generate
        always@(posedge m_axi_aclk)
        begin
        	if (!m_axi_aresetn)
        	begin
        		intr_gen[i] <= #tDLY 4'b0000;
        		
        		usr_irq_req_r[i] <= #tDLY 1'b0;
        					
        		fifo_rdreq[i] <= #tDLY 1'b0;
        	end
        	else
        	begin
        		case (intr_gen[i])
        			4'b0000 :				    // Transaction link-up
        			begin							
        				if (pcie_lnk_up_r2)					 	 
        				begin								
        					intr_gen[i] <= #tDLY 4'b0001;
        				end
        				
        				usr_irq_req_r[i] <= #tDLY 1'b0;
        					
        		        fifo_rdreq[i] <= #tDLY 1'b0;
        			end
        			
        			4'b0001 :				    // wait for INTR FIFO Ready
        			begin
        				if ((!fifo_empty[i]) && usr_intr_en_mask[i])
        				begin
        				    if (msi_enable_r2)
        				    begin
        					    intr_gen[i] <= #tDLY 4'b0010;
        				    end
        				    else
        				    begin
        				        intr_gen[i] <= #tDLY 4'b0100;
        				    end
        					
        					usr_irq_req_r[i] <= #tDLY 1'b1;
        					
        					fifo_rdreq[i] <= #tDLY 1'b1;
        				end
        			end
        			
        			4'b0010 :                   // wait for user msi interrupt ack
        			begin
        			    if (usr_irq_ack[i])
        			    begin
        			        intr_gen[i] <= #tDLY 4'b0011;
        			    end
        			    
        			    fifo_rdreq[i] <= #tDLY 1'b0;
        			end
        			
        			4'b0011 :                   // wait for software to reset user interrupt
        			begin
        			    if (!usr_intr_en_mask[i])
        			    begin
        			        intr_gen[i] <= #tDLY 4'b1000;
        			        
        			        usr_irq_req_r[i] <= #tDLY 1'b0;
        			    end
        			end 
        			
        			4'b0100 :                   // wait for user legacy interrupt ack
        			begin
        			    if (usr_irq_ack[i])
        			    begin
        			        intr_gen[i] <= #tDLY 4'b0101;
        			    end
        			    
        			    fifo_rdreq[i] <= #tDLY 1'b0;
        			end 
        			
        			4'b0101 :                   // wait for deassertion message for the legacy interrupt sent or software to reset user interrupt
        			begin
        			    if (usr_irq_ack[i] && (!usr_intr_en_mask[i]))
        			    begin
        			        intr_gen[i] <= #tDLY 4'b1000;
        			        
        			        usr_irq_req_r[i] <= #tDLY 1'b0;
        			    end
        			    else if (!usr_intr_en_mask[i])
        			    begin
        			        intr_gen[i] <= #tDLY 4'b0110;
        			        
        			        usr_irq_req_r[i] <= #tDLY 1'b0;
        			    end
        			    else if (usr_irq_ack[i])
        			    begin
        			        intr_gen[i] <= #tDLY 4'b0111;
        			    end
        			end 
        			
        			4'b0110 :                   // wait for deassertion message for the legacy interrupt sent
        			begin
        			    if (usr_irq_ack[i])
        			    begin
        			        intr_gen[i] <= #tDLY 4'b1000;
        			    end
        			end 
        			
        			4'b0111 :                   // wait for software to reset user interrupt
        			begin
        			    if (!usr_intr_en_mask[i])
        			    begin
        			        intr_gen[i] <= #tDLY 4'b1000;
        			        
        			        usr_irq_req_r[i] <= #tDLY 1'b0;
        			    end
        			end 
        			
        			4'b1000 :                   // wait for software to enable user interrupt
        			begin
        			    if (usr_intr_en_mask[i])
        			    begin
        			        intr_gen[i] <= #tDLY 4'b0001;
        			    end
        			end
        			
        			default :
        			begin
        				intr_gen[i] <= #tDLY 'bx;
        		
                		usr_irq_req_r[i] <= #tDLY 1'bx;
                					
                		fifo_rdreq[i] <= #tDLY 1'bx;
        			end
        		endcase
        	end
        end
    end
end
endgenerate





// INTR Generate
always@(posedge m_axi_aclk)
begin
	if (!m_axi_aresetn)
	begin
		pcie_reg_state <= #tDLY pcie_reg_idle;
		
		m_axil_arvalid_r <= #tDLY 1'b0;
	end
	else
	begin
		case (pcie_reg_state)
		    pcie_reg_idle :
		    begin
		        if (pcie_lnk_up_r2)
		        begin
		            pcie_reg_state <= #tDLY pcie_reg_rd_pre;
		        end
		        
		        m_axil_arvalid_r <= #tDLY 1'b0;
		    end
		    
		    pcie_reg_rd_pre :
		    begin
		        pcie_reg_state <= #tDLY pcie_reg_rd;
		    end
		    
		    pcie_reg_rd :
		    begin
		        pcie_reg_state <= #tDLY pcie_reg_rd_ack;
		        
                m_axil_arvalid_r <= #tDLY 1'b1; 
		    end
		    
		    pcie_reg_rd_ack :
		    begin
		        if (m_axil_arready)
		        begin
		            pcie_reg_state <= #tDLY pcie_reg_rd_dat;
		            
		            m_axil_arvalid_r <= #tDLY 1'b0;
		        end
		    end
		    
		    pcie_reg_rd_dat :
		    begin
		        if (m_axil_rvalid)
		        begin
		            pcie_reg_state <= #tDLY pcie_reg_rd_pre;
		        end
		    end
		    
		    default :
		    begin
		        pcie_reg_state <= #tDLY 'bx;
		
		        m_axil_arvalid_r <= #tDLY 1'bx;
		    end
		endcase
	end
end        		    
        	
        	
always@(posedge m_axi_aclk)
begin
    if (pcie_reg_state == pcie_reg_rd_pre)
    begin
        pcie2dma_addr <= #tDLY 16'h2004;
    end
end	


always@(posedge m_axi_aclk)
begin
    if (pcie_reg_state == pcie_reg_rd)
    begin
        m_axil_araddr_r <= #tDLY {16'h0000, pcie2dma_addr};
    end
end	    
        		

always@(posedge m_axi_aclk)
begin
	if (!m_axi_aresetn)
	begin
		usr_intr_en_mask <= #tDLY 0;
	end
	else
	begin
	    if ((pcie_reg_state == pcie_reg_rd_dat) && m_axil_rvalid)
	    begin
	        usr_intr_en_mask <= #tDLY m_axil_rdata[15:0];
	    end
	end    
end






endmodule