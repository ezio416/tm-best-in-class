// c 2025-05-17
// m 2025-05-17

[SettingsTab name="Debug" icon="Bug"]
void RenderDebug() {
    if (UI::BeginTable("##table-debug", 2, UI::TableFlags::RowBg)) {
        UI::PushStyleColor(UI::Col::TableRowBgAlt, vec4(vec3(), 0.5f));

        UI::TableSetupColumn("name", UI::TableColumnFlags::WidthFixed);
        UI::TableSetupColumn("value");

        UI::TableNextRow();
        UI::TableNextColumn();
        UI::Text("local PB");
        UI::TableNextColumn();
        const uint localPB = GetLocalPB();
        UI::Text(Time::Format(localPB != maxUint ? localPB : 0));

        UI::TableNextRow();
        UI::TableNextColumn();
        const uint schoolPB = GetSchoolPB();
        UI::Text("school PB");
        UI::TableNextColumn();
        UI::Text(Time::Format(schoolPB != maxUint ? schoolPB : 0));

        UI::TableNextRow();
        UI::TableNextColumn();
        UI::Text("PB");
        UI::TableNextColumn();
        UI::Text(Time::Format(pb != maxUint ? pb : 0));

        UI::PopStyleColor();
        UI::EndTable();
    }

    UI::Separator();

    UI::Text(Json::Write(currentMap, true));
}
