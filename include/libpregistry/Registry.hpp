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
#ifndef REGISTRY_HPP
#define REGISTRY_HPP

#include <map>
#include <memory>
#include <vector>

#include "libpregistry/RegistryEntry.hpp"
namespace pregistry
{
    class Registry {
    public:
        using RegistryKeyPair = std::pair<std::string, RegistryEntry>;
        using RegistryMap = std::map<std::string, RegistryEntry>;
    private:
        std::map<std::string, RegistryEntry> REG_MAP;

    public:
        friend class RegistryEntry;
        Registry();
        virtual  ~Registry();
        Registry(std::initializer_list<std::pair<const std::string, RegistryEntry>> list);
        bool has_key(const std::string& key) const;

        std::vector<std::string> get_keys();

        size_t GetNumberOfEntry();
        RegistryEntry& operator[](const std::string& key);
        RegistryEntry& get(const std::string& key);
        RegistryEntry& pget(const std::string& key);
    };
}
#if 1 == 0
std::vector<std::string> pregistry_parse_pget_keys(std::string pkey)
#endif

#endif //REGISTRY_HPP
