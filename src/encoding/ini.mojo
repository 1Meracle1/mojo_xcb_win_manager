from collections import Dict, List
from utils import Variant, StringSlice

struct Ini:
    alias Value = Variant[Int, Float64, Bool, String]
    alias ValueMap = Dict[String, Self.Value]
    alias ValueStrList = List[String]
    alias Section = Variant[Self.ValueMap, Self.ValueStrList]
    alias Map = Dict[String, Self.Section]

    @staticmethod
    fn load_from_path(file_path: String) raises -> Self.Map:
        var res = Self.Map()
        with open(file_path, "r") as file:
            var bytes = file.read_bytes()
            if not bytes:
                raise Error("File " + file_path + " is empty")
            bytes.append(0)
            var file_data: String = bytes

            var section_name = String()
            var section = Self.Section(Self.ValueMap())

            var lines = file_data.split("\n")
            for line_data in lines:
                var line: String = line_data[].strip()
                var comment_start_idx = line.find(";")
                if comment_start_idx != -1:
                    line = line[:comment_start_idx]
                if not line:
                    continue

                if line[0] == "[":
                    var end_idx = line.find("]")
                    if end_idx == -1:
                        raise Error(
                            "section line with opening '[' but without"
                            " closing ']'"
                        )

                    if section_name:
                        res[section_name] = section

                    var line_len = line.__len__()
                    if line_len > 2 and line[1] == "[":
                        section_name = line[2 : line_len - 2].strip()
                        section = Self.Section(Self.ValueStrList())
                    else:
                        section_name = line[1 : line_len - 1].strip()
                        section = Self.Section(Self.ValueMap())

                    continue

                if not section_name:
                    raise Error("No section name populated")

                if section.isa[Self.ValueMap]():
                    var equal_idx = line.find("=")
                    if equal_idx == -1:
                        raise Error(
                            "No equals sign found for non-empty line belonging"
                            " to Ini's ValueMap"
                        )
                    var key = String(line[:equal_idx].strip().strip('"'))
                    var value = line[equal_idx + 1 :].strip().strip('"')
                    var value_map = section._get_ptr[Self.ValueMap]()
                    value_map[][key] = Self._value_from_string(value)
                else:
                    section._get_ptr[Self.ValueStrList]()[].append(line)

            if section_name:
                res[section_name] = section

        return res

    @staticmethod
    fn _value_from_string(strval: String) -> Self.Value:
        if not strval:
            return Self.Value(strval)

        if strval == "true" or strval == "True":
            return Self.Value(True)
        if strval == "false" or strval == "False":
            return Self.Value(False)

        var is_floating_number = False
        for i in range(strval.__len__()):
            var c = strval[i]
            if not c.isdigit():
                if i == 0 and c == "-":
                    pass
                elif not is_floating_number and c == ".":
                    is_floating_number = True
                else:
                    return Self.Value(strval)

        if is_floating_number:
            try:
                return Self.Value(atof(strval))
            except:
                return Self.Value(strval)

        try:
            return Self.Value(atol(strval))
        except:
            return Self.Value(strval)
