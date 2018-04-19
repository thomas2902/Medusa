<style scoped>
    /* =========================================================================
    Style for the anidbReleaseGroupUi.mako.
    Should be moved from here, when moving the .vue files.
    ========================================================================== */

    div#anidb-release-group-ui-wrapper {
        clear: both;
    }

    div#anidb-release-group-ui-wrapper ul {
        border-style: solid;
        border-width: thin;
        padding: 5px 2px 2px 5px;
        list-style: none;
    }

    div#anidb-release-group-ui-wrapper li.active {
        background-color: cornflowerblue;
    }

    div#anidb-release-group-ui-wrapper div.arrow img {
        height: 32px;
        width: 32px;
    }

    div#anidb-release-group-ui-wrapper {
        margin-bottom: 20px;
    }

    img.deleteFromWhitelist, img.deleteFromBlacklist {
        float: right;
    }
</style>
<script type="text/x-template" id="anidb-release-group-ui">
    <div id="anidb-release-group-ui-wrapper" class="top-10">
        <div class="row">
            <div class="col-sm-4 left-whitelist" >
                <span>Whitelist</span><img v-if="showDeleteFromWhitelist" class="deleteFromWhitelist" src="images/no16.png" @click="deleteFromList('whitelist')"/>
                <ul>
                    <li @click="item.toggled = !item.toggled" v-for="item in itemsWhitelist" v-bind:class="{active: item.toggled}">{{ item.name }}</li>
                    <div class="arrow" @click="moveToList('whitelist')">
                        <img src="images/curved-arrow-left.png"/>
                    </div>
                </ul>
            </div>
            <div class="col-sm-4 center-available">
                <span>Release groups</span>
                <ul>
                    <li v-for="release in itemsReleaseGroups" class="initial" v-bind:class="{active: release.toggled}" @click="release.toggled = !release.toggled">{{ release.name }}</li>
                    <div class="arrow" @click="moveToList('releasegroups')">
                        <img src="images/curved-arrow-left.png"/>
                    </div>
                </ul>
            </div>
            <div class="col-sm-4 right-blacklist">
                <span>Blacklist</span><img v-if="showDeleteFromBlacklist" class="deleteFromBlacklist" src="images/no16.png" @click="deleteFromList('blacklist')"/>
                <ul>
                    <li @click="release.toggled = !release.toggled" v-for="release in itemsBlacklist" v-bind:class="{active: release.toggled}">{{ release.name }}</li>
                    <div class="arrow" @click="moveToList('blacklist')">
                        <img src="images/curved-arrow-left.png"/>
                    </div>
                </ul>
            </div>
        </div>
        <div id="add-new-release-group">
            <input type="text" v-model="newGroup" />
        </div>
    </div>
</script>
<script>
Vue.component('anidb-release-group-ui', {
    name: 'anidb-release-group-ui',
    template: '#anidb-release-group-ui',
    props: {
        series: {
            type: Object,
            required: true
        },
        blacklist: {
            type: Array,
            default: []
        },
        whitelist: {
            type: Array,
            default: []
        },
        allGroups: {
            type: Array,
            default: []
        }
    },
    data() {
        return {
            index: 0,
            releaseSeries: {},
            allReleaseGroups: [],
            newGroup: ''
        };
    },
    mounted() {
        this.releaseSeries = this.series;
        this.createIndexedObjects(this.blacklist, 'blacklist');
        this.createIndexedObjects(this.whitelist, 'whitelist');
        this.createIndexedObjects(this.allGroups, 'releasegroups');
    },
    methods: {
        toggleItem(release) {
            this.allReleaseGroups = this.allReleaseGroups.map(x => {
                if (x.id === release.id) {
                    x.toggled = !x.toggled;
                }
                return x;
            });
        },
        createIndexedObjects(releaseGroups, list) {
            newList = [];
            for (release of releaseGroups) {

                // Whitelist and blacklist pass an array of strings not objects.
                if (typeof(release) === 'string') {
                    release = { name: release };
                }

                // Merge the passed object with some additional information.
                itemAsObject = Object.assign({
                    id: this.index,
                    toggled: false, memberOf: list
                }, release);
                this.allReleaseGroups.push(itemAsObject);
                this.index += 1; // increment the counter for our next item.
            }
        },
        moveToList(list) {
            // Only move items that have been toggled and that are not yet in that list.
            // It's matching them by item.name.
            for (group of this.allReleaseGroups) {
                const inList = this.allReleaseGroups.map(releaseGroup => {
                    if (releaseGroup.memberOf == list) {
                        return releaseGroup.name;
                    }
                }).includes(group.name);

                if (group.toggled && !inList) {
                    group.toggled = false;
                    group.memberOf = list;
                }
            }

            if (this.newGroup) {
                this.allReleaseGroups.push({
                    id: this.index,
                    name: this.newGroup,
                    toggled: false,
                    memberOf: list
                })
                this.index += 1;
                this.newGroup = '';
            }
        },
        deleteFromList(list) {
            this.allReleaseGroups = this.allReleaseGroups.filter(x => x.memberOf !== list || !x.toggled);
        }
    },
    computed: {
        itemsWhitelist() {
            return this.allReleaseGroups.filter(x => x.memberOf == 'whitelist');
        },
        itemsBlacklist() {
            return this.allReleaseGroups.filter(x => x.memberOf == 'blacklist');
        },
        itemsReleaseGroups() {
            return this.allReleaseGroups.filter(x => x.memberOf == 'releasegroups');
        },
        showDeleteFromWhitelist() {
            return this.allReleaseGroups.filter(x => x.memberOf == 'whitelist' && x.toggled == true).length !== 0;
        },
        showDeleteFromBlacklist() {
            return this.allReleaseGroups.filter(x => x.memberOf == 'blacklist' && x.toggled == true).length !== 0;
        }
    },
    watch: {
        allReleaseGroups() {
            this.$emit('change', this.allReleaseGroups);
        }
    }
});
</script>