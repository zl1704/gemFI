#ifndef INIREADER_HPP
#define INIREADER_HPP
#include <string>
#include <map>
#include <vector>


class IniReader
{
	private:
		// Ini Container
		std::map<std::string, std::map<std::string, std::string>> iniContainer;
		
		// split Line into key and value
		std::vector<std::string> splitLine(const std::string &line, char delim);


	public:
		// File Methods
		bool readFromFile(const std::string &filename);

		bool writeToFile(const std::string &filename);


		// Section Methods
		bool addSection(const std::string &section);

		bool renameSection(const std::string &oldSection, const std::string &newSection);

		bool deleteSection(const std::string &section);


		// Key Methods
		bool addKey(const std::string &section, const std::string &key, const std::string &value);

		bool renameKey(const std::string &section, const std::string &oldKey, const std::string &newKey);

		bool deleteKey(const std::string &section, const std::string &key);
		
		
		// Value Methods
		bool changeValue(const std::string &section, const std::string &key, const std::string &value);

		std::string getValue(const std::string &section, const std::string &key);
};

#endif
