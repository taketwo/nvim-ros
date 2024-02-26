from functools import partial
from pathlib import Path
from typing import List, Tuple

import rosmsg
import rospkg


def _list_types(kind: str) -> List[Tuple[str, str]]:
    """List all ROS types of a given kind in all packages.

    Returns a list of tuples (name, path) where name is the full name of the type in
    the form package_name/TypeName and path is the absolute path to the type
    declaration file.
    """
    rospack = rospkg.RosPack()
    pkgs = rospack.list()
    packs = []
    for p in pkgs:
        package_paths = rosmsg._get_package_paths(p, rospack)
        for package_path in package_paths:
            d = Path(package_path) / kind
            if d.is_dir():
                packs.append((p, d))
    types = []
    kind_suffix = f".{kind}"
    for p, d in packs:
        types.extend(
            [
                (f"{p}/{file}", str((d / file).with_suffix(kind_suffix)))
                for file in rosmsg._list_types(d, kind, kind_suffix)
            ],
        )
    return types


list_messages = partial(_list_types, "msg")
list_services = partial(_list_types, "srv")
