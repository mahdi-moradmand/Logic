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

#ifndef LOGIC_AXI4_STREAM_PACKET_HPP
#define LOGIC_AXI4_STREAM_PACKET_HPP

#include "logic/bitstream.hpp"

#include <uvm>

#include <vector>
#include <cstdint>

namespace logic {
namespace axi4 {
namespace stream {

class packet : public uvm::uvm_object {
public:
    UVM_OBJECT_UTILS(logic::axi4::stream::packet)

    bitstream tid;
    bitstream tdest;
    std::vector<bitstream> tuser;
    std::vector<std::uint8_t> tdata;
    std::vector<sc_core::sc_time> tdata_timestamp;
    std::vector<sc_core::sc_time> transfer_timestamp;
    std::size_t bus_size;

    packet();

    packet(const std::string& name);

    packet(packet&&) = default;

    packet(const packet&) = default;

    packet& operator=(packet&&) = default;

    packet& operator=(const packet&) = default;

    packet& clear();

    virtual std::string convert2string() const override;

    virtual ~packet() override;
protected:
    virtual void do_print(const uvm::uvm_printer& printer) const override;

    virtual void do_pack(uvm::uvm_packer& p) const override;

    virtual void do_unpack(uvm::uvm_packer& p) override;

    virtual void do_copy(const uvm::uvm_object& rhs) override;

    virtual bool do_compare(const uvm::uvm_object& rhs,
            const uvm::uvm_comparer* comparer = nullptr) const override;
};

}
}
}

#endif /* LOGIC_AXI4_STREAM_PACKET_HPP */