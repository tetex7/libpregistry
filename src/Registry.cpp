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

#include "sstream"
#include "libpregistry/Registry.hpp"

#include <cstring>
#include <iostream>
using std::operator ""s;

std::vector<std::string> pregistry_parse_pget_keys(const std::string& pkey)
{
    std::vector<std::string> result;
    std::string currentToken;
    //bool insideQuotes = false;

    for (char c : pkey) {
        if (c == '/' || c == '\\') {
            if (!currentToken.empty()) {
                result.push_back(currentToken);
                currentToken.clear();
            }
        } else {
            currentToken += c;
        }
    }

    // Add the last token if it exists
    if (!currentToken.empty()) {
        result.push_back(currentToken);
    }

    return result;
}

namespace pregistry
{
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

    RegistryEntry& Registry::get(const std::string& key)
    {
        return (*this)[key];
    }
    RegistryEntry& Registry::pget(const std::string& key)
    {
        std::vector<std::string> reg_path = pregistry_parse_pget_keys(key);
        const size_t key_path_size = reg_path.size();
        const std::string& lasy_key = reg_path[key_path_size - 1];
        Registry* courrt_reg = this;
        for(const std::string& pkey : reg_path)
        {
            if (courrt_reg->has_key(pkey))
            {
                if (!(*courrt_reg)[pkey].is<Registry>() && (pkey != lasy_key))
                {
                    throw std::runtime_error("one or more key is not a Registry\n");
                }
                else if (pkey == lasy_key)
                {
                    return (*courrt_reg)[pkey];
                }
            }
            else
            {
                throw std::runtime_error("key dosn't exist\nKEY: \""s + pkey + "\"\nPKEY: \"" + key + "\"\n");
            }

            courrt_reg = &(*courrt_reg)[pkey].as<Registry&>();
        }

        throw std::runtime_error("HOW THE F... did you do this");
    }

    Registry::~Registry(){}
}
