<template>
  <form class="article-form">
    <v-text-field outline single-line v-model="title" name="title" label="タイトル" class="title-form"></v-text-field>
      <v-textarea
        outline
        no-resize
        height="100%"
        v-model="text"
        name="text"
        label="プログラミング知識をMarkdown記法で書いて共有しよう"
        class="body-form"
      ></v-textarea>
    <div class="text-xs-right">
      <v-btn
        @click="createOrUpdateArticle('published')"
        color="#55c500"
        class="font-weight-bold white--text"
      >Qiitaに投稿</v-btn>
      <v-btn
        @click="createOrUpdateArticle('draft')"
        color="#55c500"
        class="font-weight-bold white--text"
      >下書き投稿</v-btn>
    </div>
  </form>
</template>

<script lang="ts">
import axios from "axios";
import { Vue, Component } from "vue-property-decorator";
import Router from "../router/router";
const headers = {
  headers: {
    Authorization: "Bearer",
    "Access-Control-Allow-Origin": "*",
    "access-token": localStorage.getItem("access-token"),
    client: localStorage.getItem("client"),
    uid: localStorage.getItem("uid")
  }
};
@Component
export default class EditDraftArticleContainer extends Vue {
  id: string = "";
  title: string = "";
  text: string = "";
  async mounted(): Promise<void> {
    if (this.$route.params.id) {
      await this.fetchArticle(this.$route.params.id);
    }
  }
  async created(): Promise<void> {

  }
  async fetchArticle(id: string): Promise<void> {
    await axios
      .get(`/api/v1/drafts/${id}`, headers)
      .then(response => {
        this.id = response.data.id;
        this.title = response.data.title;
        this.text = response.data.text;
      })
      .catch(e => {
        // TODO: 適切な Error 表示
        alert(e.response.statusText);
      });
  }
  async createOrUpdateArticle(status: string): Promise<void> {
    enum Statuses {
      "draft" = "draft",
      "published" = "published"
    }
    const params = {
      title: this.title,
      text: this.text,
      status: Statuses[status]
    };
    if (this.id) {
      // update
      await axios
        .patch(`/api/v1/articles/${this.id}`, params, headers)
        .then(_response => {
          if (status == Statuses["published"]) {
            Router.push("/");
          } else {
            Router.push("/drafts");
          }
        })
        .catch(e => {
          // TODO: 適切な Error 表示
          alert(e.response.data.errors);
        });
    } else {
      // create
      await axios
        .post("/api/v1/articles", params, headers)
        .then(_response => {
          if (status == Statuses["published"]) {
            Router.push("/");
          } else {
            Router.push("/drafts");
          }
        })
        .catch(e => {
          // TODO: 適切な Error 表示
          alert(e.response.data.errors);
        });
    }
  }
}
</script>

<style lang="scss" scoped>
.article-form {
  margin: 5px;
  height: calc(100% - 64px - 10px);
  display: flex;
  flex-flow: column;
}
.title-form {
  flex: none;
}
.edit-area {
  height: 100%;
  display: flex;
  overflow: hidden;
}
.preview {
  width: 50%;
  padding: 12px;
  margin-bottom: 8px;
  border: 2px solid rgba(0, 0, 0, 0.54);
  border-radius: 4px;
  border-left: none;
  overflow: auto;
}
</style>

<style lang="scss">
.body-form > .v-input__control {
  height: 100%;
}
.v-text-field .v-text-field__details {
  display: none;
}
</style>