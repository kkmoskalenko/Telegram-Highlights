//
//  AlignUp.swift
//  TelegramHighlights
//
//  This source file is derived from Telegram iOS:
//  https://github.com/TelegramMessenger/Telegram-iOS
//
//  Distributed under the terms of the GNU General Public License,
//  version 2 or any later version. See the LICENSE file for details.
//

import Foundation

func alignUp(_ value: Int, alignment: Int) -> Int {
    assert(((alignment - 1) & alignment) == 0)

    let alignmentMask = alignment - 1
    return ((value + alignmentMask) & (~alignmentMask))
}
