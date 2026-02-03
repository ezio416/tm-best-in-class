void LoadCurrentMap() {
    CGameCtnApp@ App = GetApp();

    if (App.RootMap is null) {
        return;
    }

    const string uid = App.RootMap.EdChallengeId;
    const string path = IO::FromStorageFolder(uid + ".json");

    bool exists = false;

    if (IO::FileExists(path)) {
        try {
            @currentMap = Json::FromFile(path);
        } catch {
            warn("failed to load file");
            return;
        }

        if (true
            and currentMap.GetType() == Json::Type::Object
            and currentMap.HasKey("uid")
            and currentMap["uid"].GetType() == Json::Type::String
            and currentMap.HasKey("pbs")
            and currentMap["pbs"].GetType() == Json::Type::Array
        ) {
            exists = true;
        } else {
            warn("tried to load bad json: " + Json::Write(currentMap));
            // IO::Delete(path);
        }
    }

    if (!exists) {
        @currentMap = Json::Object();
        currentMap["uid"] = uid;
        currentMap["pbs"] = Json::Array();
    }
}

void SaveCurrentMap() {
    if (false
        or currentMap is null
        or !currentMap.HasKey("uid")
    ) {
        warn("tried to save bad json: " + Json::Write(currentMap));
        return;
    }

    const string uid = string(currentMap["uid"]);
    const string path = IO::FromStorageFolder(uid + ".json");

    try {
        Json::ToFile(path, currentMap, true);
    } catch {
        warn("failed to save file");
    }
}
