from pathlib import Path
from typing import List, Tuple

import rosmsg
import rospkg


def list_messages() -> List[Tuple[str, str]]:
    """List all ROS messages in all packages.

    Returns a list of tuples (name, path) where name is the full name of the message in
    the form package_name/MessageName and path is the absolute path to the message file.
    """
    rospack = rospkg.RosPack()
    pkgs = rospack.list()
    packs = []
    for p in pkgs:
        package_paths = rosmsg._get_package_paths(p, rospack)
        for package_path in package_paths:
            d = Path(package_path) / "msg"
            if d.is_dir():
                packs.append((p, d))
    msgs = []
    for p, d in packs:
        msgs.extend(
            [
                (f"{p}/{file}", str((d / file).with_suffix(".msg")))
                for file in rosmsg._list_types(d, "msg", ".msg")
            ],
        )
    return msgs
