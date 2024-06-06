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
#include "libpregistry/Registry.hpp"

Registry::Registry()
{}

Registry::Registry(std::initializer_list<std::pair<const std::string, RegistryEntry>> list)
: REG_MAP(list){}

bool Registry::has_key(const std::string& key) const
{
    return  this->REG_MAP.contains(key);
}

std::vector<std::string> Registry::get_keys()
{
    std::vector<std::string> keys;
    for(const auto& rdata : this->REG_MAP)
    {
        keys.push_back(rdata.first);
    }
    return keys;
}

size_t Registry::GetNumberOfEntry()
{
    return this->REG_MAP.size();
}

RegistryEntry& Registry::operator[](const std::string& key)
{
    if (!has_key(key))
    {
        throw std::runtime_error(std::string("KEY: ") + key + "dos't exits");
    }
    return this->REG_MAP[key];
}

Registry::~Registry(){}
