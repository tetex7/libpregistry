//
// Created by tete on 6/6/24.
//

/*
Copyright (C) 2024  tete

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

#ifndef PEG_DEFS_HPP
#define PEG_DEFS_HPP
#include <string>

#include <any>
#include <stdexcept>
#include "libpregistry/RegistryTypes.hpp"

#ifndef PR__GOD_IM_GOING_TO_HELL_FOR_THIS__RP
#define private public
#include <any>
#undef  private
#else
#include <any>
#endif

namespace pregistry
{
    typedef unsigned char byte;
    class RegistryEntry;
    class Registry;
    using std::operator ""s;

    template<class bidata, size_t ds = (sizeof(bidata) + 1)>
    union  reg_data_pack_t
    {
        bidata val;
        char bytes[ds];
    };
}

#endif //PEG_DEFS_HPP
