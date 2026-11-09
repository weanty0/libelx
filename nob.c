#define NOB_IMPLEMENTATION
#include "nob.h"

#define LLC       "llc"
#define AR        "ar"
#define ARFLAGS   "rcs"

#define SRC_DIR   "src"
#define BUILD_DIR "build"
#define TARGET    "libelx.a"

static bool has_suffix(const char *s, const char *suffix)
{
    size_t n = strlen(s), m = strlen(suffix);
    return n >= m && strcmp(s + n - m, suffix) == 0;
}

static bool build_all(void)
{
    bool result = true;
    Nob_Cmd cmd = {0};
    Nob_File_Paths files = {0};
    Nob_File_Paths objs = {0};

    if (!nob_mkdir_if_not_exists(BUILD_DIR)) nob_return_defer(false);
    if (!nob_read_entire_dir(SRC_DIR, &files)) nob_return_defer(false);

    for (size_t i = 0; i < files.count; ++i) {
        const char *name = files.items[i];
        if (!has_suffix(name, ".ll")) continue;

        size_t stem_len = strlen(name) - strlen(".ll");
        const char *src = nob_temp_sprintf("%s/%s", SRC_DIR, name);
        const char *obj = nob_temp_sprintf("%s/%.*s.o", BUILD_DIR, (int)stem_len, name);
        nob_da_append(&objs, obj);

        if (nob_needs_rebuild1(obj, src) <= 0) continue;

        nob_cmd_append(&cmd, LLC, "-filetype=obj", "-O2", src, "-o", obj);
        if (!nob_cmd_run_sync_and_reset(&cmd)) nob_return_defer(false);
    }

    if (nob_needs_rebuild(TARGET, objs.items, objs.count) > 0) {
        nob_cmd_append(&cmd, AR, ARFLAGS, TARGET);
        nob_da_append_many(&cmd, objs.items, objs.count);
        if (!nob_cmd_run_sync_and_reset(&cmd)) nob_return_defer(false);
    }

defer:
    nob_cmd_free(cmd);
    nob_da_free(files);
    nob_da_free(objs);
    return result;
}

static bool clean(void)
{
    bool result = true;
    Nob_File_Paths files = {0};

    if (nob_file_exists(BUILD_DIR) > 0) {
        if (!nob_read_entire_dir(BUILD_DIR, &files)) nob_return_defer(false);
        for (size_t i = 0; i < files.count; ++i) {
            const char *name = files.items[i];
            if (strcmp(name, ".") == 0 || strcmp(name, "..") == 0) continue;
            const char *path = nob_temp_sprintf("%s/%s", BUILD_DIR, name);
            nob_log(NOB_INFO, "removing %s", path);
            if (remove(path) != 0) {
                nob_log(NOB_ERROR, "could not remove %s: %s", path, strerror(errno));
                nob_return_defer(false);
            }
        }
        nob_log(NOB_INFO, "removing %s", BUILD_DIR);
        if (rmdir(BUILD_DIR) != 0) nob_return_defer(false);
    }

    if (nob_file_exists(TARGET) > 0) {
        nob_log(NOB_INFO, "removing %s", TARGET);
        if (remove(TARGET) != 0) {
            nob_log(NOB_ERROR, "could not remove %s: %s", TARGET, strerror(errno));
            nob_return_defer(false);
        }
    }

defer:
    nob_da_free(files);
    return result;
}

int main(int argc, char **argv)
{
    NOB_GO_REBUILD_URSELF(argc, argv);

    const char *target = argc > 1 ? argv[1] : "all";

    if (strcmp(target, "all") == 0)   return build_all() ? 0 : 1;
    if (strcmp(target, "clean") == 0) return clean() ? 0 : 1;

    nob_log(NOB_ERROR, "unknown target '%s' (expected: all, clean)", target);
    return 1;
}
