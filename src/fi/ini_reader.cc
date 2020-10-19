#include "fi/ini_reader.hh"
#include <fstream>
#include <sstream>
#include <regex>


// split Line into key and value
std::vector<std::string> IniReader::splitLine(const std::string &line, char delim)
{
	std::stringstream ss(line);
	std::string item;
	std::vector<std::string> elems;

	while(std::getline(ss, item, delim))
	{
		elems.push_back(std::move(item));
	}

	return elems;
}


// File Methods
bool IniReader::readFromFile(const std::string &filename)
{
	std::string line;
	std::ifstream file(filename);
	std::regex brackets("\\[.*\\]");
	std::string currentSection;

	if(file)
	{
		while(std::getline(file, line))
		{
			if(std::regex_match(line, brackets))
			{
				currentSection = line.substr(1, line.size()-2);
			}
			else if(!currentSection.empty())
			{
				std::vector<std::string> result = splitLine(line, '=');

				if(result.size() == 2)
				{
					iniContainer[currentSection][result[0]] = result[1];
				}
				else
				{
					// invalid entry
				}
			}
			else
			{
				// ini doesn't start with a section
			}
		}

		file.close();
		return true;
	}
	else
	{
		// file doesn't exist
		return false;
	}
}

bool IniReader::writeToFile(const std::string &filename)
{
	std::ofstream file;
	file.open(filename);

	if(file)
	{	
		for(auto section : iniContainer)
		{
			file << "[" << section.first << "]" << std::endl;
	
			for(auto line : section.second)
			{
				file << line.first << "=" << line.second << std::endl;
			}
			
			file << std::endl;
		}
	
		file.close();
		return true;
	}
	else
	{
		// can't create file
		return false;
	}
}


// Section Methods
bool IniReader::addSection(const std::string &section)
{
	auto it = iniContainer.find(section);
	
	if(it == iniContainer.end())
	{
		iniContainer[section] = std::map<std::string, std::string>();
		return true;
	}
	else
	{
		// section allready exist
		return false;
	}
}

bool IniReader::renameSection(const std::string &oldSection, const std::string &newSection)
{
	auto oldIt = iniContainer.find(oldSection);
	auto newIt = iniContainer.find(newSection);
	
	if(oldIt != iniContainer.end() && newIt == iniContainer.end())
	{
		iniContainer[newSection] = iniContainer[oldSection];
		iniContainer.erase(oldSection);
		return true;
	}
	else
	{
		// can't rename section
		return false;
	}
}

bool IniReader::deleteSection(const std::string &section)
{
	auto it = iniContainer.find(section);
	
	if(it != iniContainer.end())
	{
		iniContainer[section].clear();
		iniContainer.erase(section);
		return true;
	}
	else
	{
		// section doesn't exist
		return false;
	}
}


// Key Methods
bool IniReader::addKey(const std::string &section, const std::string &key, const std::string &value)
{
	auto secIt = iniContainer.find(section);
	
	if(secIt != iniContainer.end())
	{
		auto keyIt = iniContainer[section].find(key);
		
		if(keyIt == iniContainer[section].end())
		{
			iniContainer[section][key] = value;
			return true;	
		}
		else
		{
			// key does allready exist
			return false;
		}
	}
	else
	{
		// section doesn't exist
		return false;
	}
}

bool IniReader::renameKey(const std::string &section, const std::string &oldKey, const std::string &newKey)
{
	auto secIt = iniContainer.find(section);
	
	if(secIt != iniContainer.end())
	{
		auto oldIt = iniContainer[section].find(oldKey);
		auto newIt = iniContainer[section].find(newKey);
		
		if(oldIt != iniContainer[section].end() && newIt == iniContainer[section].end())
		{
			iniContainer[section][newKey] = iniContainer[section][oldKey];
			iniContainer[section].erase(oldKey);
			return true;
		}
		else
		{
			// can't rename key
			return false;
		}
	}
	else
	{
		// section doesn't exist
		return false;
	}
}

bool IniReader::deleteKey(const std::string &section, const std::string &key)
{
	auto secIt = iniContainer.find(section);
	
	if(secIt != iniContainer.end())
	{
		auto keyIt = iniContainer[section].find(key);
		
		if(keyIt != iniContainer[section].end())
		{
			iniContainer[section].erase(key);
			return true;	
		}
		else
		{
			// key doesn't exist
			return false;
		}
	}
	else
	{
		// section doesn't exist
		return false;
	}
}


// Value Methods
bool IniReader::changeValue(const std::string &section, const std::string &key, const std::string &value)
{
	auto secIt = iniContainer.find(section);
	
	if(secIt != iniContainer.end())
	{
		auto keyIt = iniContainer[section].find(key);
		
		if(keyIt != iniContainer[section].end())
		{
			iniContainer[section][key] = value;
			return true;	
		}
		else
		{
			// key doesn't exist
			return false;
		}
	}
	else
	{
		// section doesn't exist
		return false;
	}
}

std::string IniReader::getValue(const std::string &section, const std::string &key)
{
	auto secIt = iniContainer.find(section);
	
	if(secIt != iniContainer.end())
	{
		auto keyIt = iniContainer[section].find(key);
		
		if(keyIt != iniContainer[section].end())
		{
			return iniContainer[section][key];
		}
		else
		{
			// key doesn't exist
			return "";
		}
	}
	else
	{
		// section doesn'T exist
		return "";
	}
}
