/* Copyright 2017 Tymoteusz Blazejczyk
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

`include "logic.svh"

module logic_basic_queue_generic_read #(
    int DATA_WIDTH = 1,
    int ADDRESS_WIDTH = 1
) (
    input aclk,
    input areset_n,
    /* Tx */
    input tx_tready,
    output logic tx_tvalid,
    output logic [DATA_WIDTH-1:0] tx_tdata,
    /* Read */
    input [DATA_WIDTH-1:0] read_data,
    output logic [ADDRESS_WIDTH-1:0] read_pointer,
    output logic read_enable,
    /* Capacity */
    input capacity_valid
);
    enum logic [0:0] {
        FSM_IDLE,
        FSM_DATA
    } fsm_state;

    always_ff @(posedge aclk or negedge areset_n) begin
        if (!areset_n) begin
            read_pointer <= '0;
        end
        else if (read_enable) begin
            read_pointer <= read_pointer + 1'b1;
        end
    end

    always_ff @(posedge aclk or negedge areset_n) begin
        if (!areset_n) begin
            fsm_state <= FSM_IDLE;
        end
        else begin
            unique case (fsm_state)
            FSM_IDLE: begin
                if (capacity_valid) begin
                    fsm_state <= FSM_DATA;
                end
            end
            FSM_DATA: begin
                if (tx_tready && !capacity_valid) begin
                    fsm_state <= FSM_IDLE;
                end
            end
            endcase
        end
    end

    always_comb begin
        unique case (fsm_state)
        FSM_IDLE: begin
            read_enable = capacity_valid;
        end
        FSM_DATA: begin
            read_enable = capacity_valid && tx_tready;
        end
        endcase
    end

    always_ff @(posedge aclk or negedge areset_n) begin
        if (!areset_n) begin
            tx_tvalid <= '0;
        end
        else if (tx_tready) begin
            tx_tvalid <= (FSM_DATA == fsm_state);
        end
    end

    always_ff @(posedge aclk) begin
        if (tx_tready) begin
            tx_tdata <= read_data;
        end
    end
endmodule