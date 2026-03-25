//
//  loki_header.metal
//  TelegramHighlights
//
//  This source file is derived from Telegram iOS:
//  https://github.com/TelegramMessenger/Telegram-iOS
//
//  Distributed under the terms of the GNU General Public License,
//  version 2 or any later version. See the LICENSE file for details.
//

// MIT License
//
// Copyright (c) 2024 Youssef Victor
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

/*
 * Loki Random Number Generator
 * Copyright (c) 2017 Youssef Victor All rights reserved.
 *
 *      Function                        Result
 *      ------------------------------------------------------------------
 *
 *      TausStep                        Combined Tausworthe Generator or
 *                                      Linear Feedback Shift Register (LFSR)
 *                                      random number generator. This is a
 *                                      helper method for rng, which uses
 *                                      a hybrid approach combining LFSR with
 *                                      a Linear Congruential Generator (LCG)
 *                                      in order to produce random numbers with
 *                                      periods of well over 2^121
 *
 *      rand                            A pseudo-random number based on the
 *                                      method outlined in "Efficient
 *                                      pseudo-random number generation
 *                                      for monte-carlo simulations using
 *                                      graphic processors" by Siddhant
 *                                      Mohanty et al 2012.
 *
 */

#include <metal_stdlib>
using namespace metal;

#ifndef LOKI
#define LOKI


class Loki {
private:
    thread float seed;
    unsigned TausStep(const unsigned z, const int s1, const int s2, const int s3, const unsigned M);

public:
    thread Loki(const unsigned seed1, const unsigned seed2 = 1, const unsigned seed3 = 1);

    thread float rand();
};

#endif
