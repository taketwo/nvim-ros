def list_messages():
    """
    List all ROS messages in all packages.

    Returns a list of tuples (name, path) where name is the full name of the message in
    the form package_name/MessageName and path is the absolute path to the message file.
    """
    import os
    import rosmsg
    import rospkg
    rospack = rospkg.RosPack()
    pkgs = rospack.list()
    packs = []
    for p in pkgs:
        package_paths = rosmsg._get_package_paths(p, rospack)
        for package_path in package_paths:
            d = os.path.join(package_path, 'msg')
            if os.path.isdir(d):
                packs.append((p, d))
    msgs = []
    for (p, direc) in packs:
        for file in rosmsg._list_types(direc, 'msg', '.msg'):
            msgs.append((f"{p}/{file}", os.path.join(direc, file) + '.msg'))
    return msgs
