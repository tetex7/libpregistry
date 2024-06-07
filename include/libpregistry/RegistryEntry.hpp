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

#ifndef REGISTRYENTRY_HPP
#define REGISTRYENTRY_HPP
#include <stdexcept>
#include "libpregistry/peg_defs.hpp"

namespace pregistry
{

    class RegistryEntry {
    private:
        RegistryEntryType dtype = RegistryEntryType::BREAK;
        std::any val;
    public:
        friend class Registry;
        RegistryEntry();

        template<class bi1>
        RegistryEntry(bi1 v)
        : val(std::make_any<bi1>(v)) {}

        RegistryEntry(const RegistryEntry& entry2);

        RegistryEntry& operator=(const RegistryEntry& entry1);

        template<class bi1>
        RegistryEntry& operator=(const bi1 entry1)
        {
            /*if (IsReadOnly)
            {
                throw std::runtime_error("Entry is Readony");
            }*/
            if (typeid(bi1) != val.type())
            {
                throw std::runtime_error(std::string(val.type().name()) + " IS NOT " + typeid(bi1).name());
            }
            this->val = std::make_any<bi1>(entry1);
            return *this;
        }

        template<typename bi>
        explicit operator bi() const
        {
            if (!val.has_value())
            {
                throw std::logic_error("no val");
            }

            if (typeid(bi) == val.type())
            {
                return std::any_cast<bi>(val);
            }
            else
            {
                throw std::runtime_error(std::string(val.type().name()) + " IS " + typeid(bi).name());
            }
        }

        bool operator==(const std::type_info& op2) const;
        bool operator!=(const std::type_info& op2) const;

        operator Registry&();

        template<typename bi>
        explicit operator bi&()
        {
            /*if (IsReadOnly)
            {
                throw std::runtime_error("Entry is Readony");
            }*/

            if (!val.has_value())
            {
                throw std::logic_error("no val");
            }

            if (typeid(bi) == val.type())
            {
                return std::any_cast<bi&>(val);
            }
            else
            {
                throw std::runtime_error(std::string(val.type().name()) + " IS " + typeid(bi).name());
            }
        }

        template<class otype>
        std::type_identity_t<otype> cast() const
        {
            auto& _this = *this;
            return (otype)_this;
        }


        template<class otype>
        std::type_identity_t<otype> as() const
        {
            return cast<otype>();
        }

        const std::any& getRaw() const;

        template<class otype>
        bool is() const
        {
            return typeid(otype) == val.type();
        }

        virtual ~RegistryEntry();
    };
}


#endif //REGISTRYENTRY_HPP
