//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

package inet.examples.cmu.vanet.addressing;

import inet.mobility.models.StationaryMobility;
import inet.linklayer.ieee80211.mac.Ieee80211Mac;
import inet.linklayer.ieee80211.radio.Ieee80211Radio;
import inet.base.NotificationBoard;

//Represents a roadside unit (basestation) in a VANET
module RSUStation
{
    parameters:
        string macAddress;
        @node();
        @display("i=vanet/RSU;r=1936,,red"); //r= draws the red range, but this is fixed to 1936
    gates:
        input radioIn @labels(AirFrame); // to receive AirFrames
    submodules:
        mobilityModel: StationaryMobility {

            @display("p=167,56");
        }

        notificationBoard: NotificationBoard {
            @display("p=167,129");
        }

        rsu: RSU {
            @display("p=275,56");
        }
        radio: Ieee80211Radio {
            bitrate = default(54Mbps);
            @display("p=275,261");
        }
        mac: Ieee80211Mac {
            address = macAddress;
            bitrate = default(54Mbps);
            @display("p=275,129");
        }
        macHack: MACHack {
            address = macAddress;
            @display("p=406,197");
        }
    connections:
        radio.radioIn <-- radioIn;
        radio.upperLayerIn <-- mac.lowerLayerOut;
        radio.upperLayerOut --> macHack.hackedIn;

        macHack.hackedOut --> mac.lowerLayerIn;

        mac.upperLayerIn <-- rsu.rsuOut;
        mac.upperLayerOut --> rsu.rsuIn;
}
