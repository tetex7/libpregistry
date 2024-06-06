//
// Created by tete on 6/5/24.
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
#include "libpregistry/RegistryEntry.hpp"
#include "libpregistry/Registry.hpp"

RegistryEntry::RegistryEntry()
: val() {}

RegistryEntry::RegistryEntry(const RegistryEntry& entry2)
: val(entry2.val){}

RegistryEntry& RegistryEntry::operator=(const RegistryEntry& entry1)
{
    if (IsReadOnly)
    {
        throw std::runtime_error("Entry is Readony");
    }
    if (entry1.val.type() != val.type())
    {
        throw std::runtime_error(std::string(val.type().name()) + " IS NOT " + entry1.val.type().name());
    }
    this->val = entry1.val;
    return *this;
}

const std::any& RegistryEntry::getRaw() const
{
    return val;
}

bool RegistryEntry::GetReadPrms() const
{
    return IsReadOnly;
}

RegistryEntry::operator Registry&()
{
    if (IsReadOnly)
    {
        throw std::runtime_error("Entry is Readony");
    }

    if (!val.has_value())
    {
        throw std::logic_error("no val");
    }
    if (typeid(Registry) == val.type())
    {
        throw std::runtime_error(std::string(val.type().name()) + " IS " + typeid(Registry).name());
    }
    return std::any_cast<Registry&>(val);
}

RegistryEntry::~RegistryEntry(){}
