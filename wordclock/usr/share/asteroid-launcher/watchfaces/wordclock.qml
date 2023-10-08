/*
 * Copyright (C) 2023 - jakob30061 <github.com/jakob30061>
 * All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as
 * published by the Free Software Foundation, either version 2.1 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.4

Item {
    id: root

    Item {
        id: watchfaceRoot

        anchors.centerIn: parent

        width: parent.width * 1
        height: width

        Text {
            function generateGrid(time, local) {
                switch(local) {
                    case "de":
                        break;

                    // en
                    default:
                        let active = [[0, 0], [0, 2]];
                        const hours = [
                            [[5,1], [5,2], [5,3]], // 1
                            [[5,0], [5,1]], // 2
                            [[6,1]], // 3
                            [[7,2]], // 4
                            [[6,3]], // 5
                            [[9,1]], // 6
                            [[5,3], [5,4]], // 7
                            [[8,1]], // 8
                            [[7,1]], // 9
                            [[8,2]], // 10
                            [[7,0]], // 11
                            [[4,2]] // 12
                        ]
                        const min = Math.round(time.getMinutes() / 5) * 5;
                        const hourIndex = ((time.getHours() + (min > 20 ? 1 : 0)) % 12) - 1;
                        active = active.concat(hours[hourIndex == -1 ? 11 : hourIndex]);

                        switch(min) {
                            case 60:
                            case 0:
                                active.push([9, 3]); break;
                            case 5:
                            case 55:
                                active.push([0, 4]);
                                active.push(getCorrectContextWord(min));
                                break;
                            case 10:
                            case 50:
                                active.push([1, 0]);
                                active.push(getCorrectContextWord(min));
                                break;
                            case 30:
                                active.push([4, 0]); break;
                            case 15:
                            case 45:
                                active.push([2, 1]); 
                                active.push(getCorrectContextWord(min));
                                break;
                            case 20:
                            case 40:
                                active.push([1, 1]);
                                active.push(getCorrectContextWord(min));
                                break;
                            case 25:
                            case 35:
                                active.push([0, 4]);
                                active.push(min > 30 ? [3, 1] : [3, 2]);
                                active.push([4, 0]);
                                break;
                        }

                        let wordgrid = [
                            ["ES", "K", "IST", "L", "FÜNF"], // 0
                            ["ZEHN", "ZWANZIG"], // 1
                            ["DREI", "VIERTEL"], // 2
                            ["TG", "NACH", "VOR", "JM"], // 3
                            ["HALB", "O", "ZWÖLF", "P"], // 4
                            ["ZW", "EI", "N", "S", "IEBEN"], // 5
                            ["K", "DREI", "RH", "FÜNF"], // 6
                            ["ELF", "NEUN", "VIER"], // 7
                            ["W", "ACHT", "ZEHN", "RS"], // 8
                            ["B", "SECHS", "FM", "UHR"] // 9
                        ]
                        active.forEach((el) => {
                            wordgrid[el[0]][el[1]] = wrapInSpan(wordgrid[el[0]][el[1]]);
                        });
                        wordgrid = wordgrid.map((row) => row.join("")).join("<br>");

                        return wordgrid;
                        break;
                }
            }

            function getCorrectContextWord(time) {
                return time < 30
                    ? [3, 2]
                    : [3, 1];
            }

            function checkIfActive(text) {
                return min < 27 ? wrapInSpan(text) : text
            }

            function wrapInSpan(text) {
                const activeColor = "#ffffff";
                return `<span style="color: ${activeColor};">${text}</span>`
            }

            id: wordGrid

            anchors {
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: -parent.height * .019
                left: parent.left
                right: parent.right
            }
            horizontalAlignment: Text.AlignHCenter
            textFormat: Text.RichText
            lineHeight: .7
            color: "#8f8f91"
            style: Text.Outline
            styleColor: "#80000000"
            font {
                family: "Monospace"
                pixelSize: parent.height * .08
                weight: Font.Light
            }
            text: generateGrid(wallClock.time, Qt.locale().name.substring(0,2))
        }
    }
}
