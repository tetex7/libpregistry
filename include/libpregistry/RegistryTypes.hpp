//
// Created by tete on 6/7/24.
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
#ifndef REGISTRYTYPES_HPP
#define REGISTRYTYPES_HPP
#include <stdint.h>
#include <utility>
namespace pregistry
{
    enum class RegistryEntryType : uint8_t
    {
        BREAK = 0,
        BOOL = 1,
        INT8 = 5,
        UINT8 = 10,
        INT16 = 15,
        UINT16 = 20,
        INT32 = 25,
        UINT32 = 30,
        INT64 = 35,
        UINT64 = 40,
        STRING = 60,
        REGISTRY = 0xFF
    };

    class Registry;
#define IS_TYPE_M(typeA, typeB) std::is_same<typeA, typeB>::value

    template<class bi>
    __inline RegistryEntryType MkRegistryEntryType()
    {
        if (IS_TYPE_M(bi, bool))
        {
            return RegistryEntryType::BOOL;
        }
        else if (IS_TYPE_M(bi, int8_t))
        {
            return RegistryEntryType::INT8;
        }
        else if (IS_TYPE_M(bi, uint8_t))
        {
            return RegistryEntryType::UINT8;
        }
        else if (IS_TYPE_M(bi, int16_t))
        {
            return RegistryEntryType::INT16;
        }
        else if (IS_TYPE_M(bi, uint16_t))
        {
            return RegistryEntryType::UINT16;
        }
        else if (IS_TYPE_M(bi, uint32_t))
        {
            return RegistryEntryType::UINT32;
        }
        else if (IS_TYPE_M(bi, uint64_t))
        {
            return RegistryEntryType::UINT64;
        }
        else if (IS_TYPE_M(bi, int64_t))
        {
            return RegistryEntryType::INT64;
        }
        else if (IS_TYPE_M(bi, Registry))
        {
            return RegistryEntryType::REGISTRY;
        }
        else if (IS_TYPE_M(bi, std::string))
        {
            return RegistryEntryType::STRING;
        }
        return RegistryEntryType::BREAK;
    }

    __inline bool operator==(RegistryEntryType a, RegistryEntryType b)
    {
        return (uint8_t)a == (uint8_t)b;
    }

    __inline bool operator!=(RegistryEntryType a, RegistryEntryType b)
    {
        return (uint8_t)a != (uint8_t)b;
    }
}

#endif //REGISTRYTYPES_HPP
