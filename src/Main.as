Json::Value@  currentMap;
bool          handledFinish = false;
const uint    maxUint       = uint(-1);
uint          pb            = maxUint;
const string  pluginColor   = "\\$FF2";
const string  pluginIcon    = Icons::University;
Meta::Plugin@ pluginMeta    = Meta::ExecutingPlugin();
const string  pluginTitle   = pluginColor + pluginIcon + "\\$G " + pluginMeta.Name;
MwId          userId        = MwId(0);
string        userName;

void Main() {
    auto App = cast<CTrackMania>(GetApp());

    while (false
        or App.UserManagerScript is null
        or App.UserManagerScript.Users.Length == 0
        or App.UserManagerScript.Users[0] is null
        or App.LocalPlayerInfo is null
    ) {
        yield();
    }

    userId = App.UserManagerScript.Users[0].Id;
    userName = App.LocalPlayerInfo.Name;

    bool inMap = false;
    bool wasInMap = false;

    while (true) {
        yield();

        inMap = InMap();

        if (wasInMap != inMap) {
            wasInMap = inMap;

            if (inMap) {
                OnEnteredMap();
            } else {
                OnExitedMap();
            }

            continue;
        }

        if (false
            or !inMap
            or !InSchool()
        ) {
            continue;
        }

        auto Playground = cast<CSmArenaClient>(App.CurrentPlayground);
        if (false
            or Playground.UIConfigs.Length == 0
            or Playground.UIConfigs[0] is null
        ) {
            continue;
        }

        if (Playground.UIConfigs[0].UISequence != CGamePlaygroundUIConfig::EUISequence::Finish) {
            handledFinish = false;
            continue;
        }

        if (handledFinish) {
            continue;
        }

        handledFinish = true;

        if (false
            or App.PlaygroundScript is null
            or App.PlaygroundScript.DataFileMgr is null
            or App.PlaygroundScript.DataFileMgr.Ghosts.Length == 0
        ) {
            continue;
        }

        CGameGhostScript@ ghost;
        for (int i = App.PlaygroundScript.DataFileMgr.Ghosts.Length - 1; i >= 0; i--) {
            @ghost = App.PlaygroundScript.DataFileMgr.Ghosts[i];
            if (true
                and ghost !is null
                and ghost.Result !is null
                and ghost.Result.Time < pb
                and ghost.Nickname == userName
            ) {
                pb = ghost.Result.Time;
                print("new PB: " + Time::Format(pb));
                Json::Value@ newPB = Json::Object();
                newPB["time"] = pb;
                newPB["timestamp"] = Time::Stamp;
                currentMap["pbs"].Add(newPB);
                SaveCurrentMap();
                break;
            }
        }
    }
}

void Render() {
    if (false
        or !S_Enabled
        or (true
            and S_HideWithGame
            and !UI::IsGameUIVisible()
        )
        or (true
            and S_HideWithOP
            and !UI::IsOverlayShown()
        )
        or !InMap()
        or (true
            and S_OnlyShowInSchool
            and !InSchool()
        )
    ) {
        return;
    }

    int flags = 0
        | UI::WindowFlags::AlwaysAutoResize
        | UI::WindowFlags::NoFocusOnAppearing
        | UI::WindowFlags::NoTitleBar
    ;
    if (!UI::IsOverlayShown()) {
        flags |= UI::WindowFlags::NoMove;
    }

    if (UI::Begin(pluginTitle + "###bestinclass", S_Enabled, flags)) {
        UI::Text(pluginColor + pluginIcon + "\\$G " + (pb != maxUint ? Time::Format(pb) : "-:--.---"));
    }
    UI::End();
}

void RenderMenu() {
    if (UI::MenuItem(pluginTitle, "", S_Enabled)) {
        S_Enabled = !S_Enabled;
    }
}

void OnEnteredMap() {
    LoadCurrentMap();
    pb = GetPB();
}

void OnExitedMap() {
    @currentMap = null;
    pb = maxUint;
}
