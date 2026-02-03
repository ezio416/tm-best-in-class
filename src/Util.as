uint GetLocalPB() {
    auto App = cast<CTrackMania>(GetApp());

    if (false
        or userId.Value == 0
        or App.RootMap is null
        or App.MenuManager is null
        or App.MenuManager.MenuCustom_CurrentManiaApp is null
        or App.MenuManager.MenuCustom_CurrentManiaApp.ScoreMgr is null
    ) {
        return maxUint;
    }

    return App.MenuManager.MenuCustom_CurrentManiaApp.ScoreMgr.Map_GetRecord_v2(
        App.UserManagerScript.Users[0].Id,
        App.RootMap.EdChallengeId,
        "PersonalBest",
        "",
        "TimeAttack",
        ""
    );
}

uint GetPB() {
    const uint localPB = GetLocalPB();
    const uint schoolPB = GetSchoolPB();

    if (localPB == maxUint) {
        return schoolPB;
    }

    if (schoolPB == maxUint) {
        return localPB;
    }

    return uint(Math::Min(localPB, schoolPB));
}

uint GetSchoolPB() {
    if (true
        and currentMap !is null
        and currentMap.GetType() == Json::Type::Object
        and currentMap.HasKey("pbs")
    ) {
        Json::Value@ pbs = currentMap["pbs"];
        if (true
            and pbs.GetType() == Json::Type::Array
            and pbs.Length > 0
        ) {
            Json::Value@ best = pbs[pbs.Length - 1];
            if (true
                and best.GetType() == Json::Type::Object
                and best.HasKey("time")
            ) {
                Json::Value@ time = best["time"];
                if (time.GetType() == Json::Type::Number) {
                    return uint(time);
                }
            }
        }
    }

    return maxUint;
}

bool InMap() {
    CGameCtnApp@ App = GetApp();

    return true
        and App.Editor is null
        and App.RootMap !is null
        and cast<CSmArenaClient>(App.CurrentPlayground) !is null
    ;
}

bool InSchool() {
    return true
#if !SIG_SCHOOL
        and false
#endif
        and !Meta::IsSchoolModeWhitelisted()
    ;
}
