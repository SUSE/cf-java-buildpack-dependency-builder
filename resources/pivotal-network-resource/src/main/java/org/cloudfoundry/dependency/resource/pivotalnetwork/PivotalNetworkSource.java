/*
 * Copyright 2017-2018 the original author or authors.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.cloudfoundry.dependency.resource.pivotalnetwork;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.Optional;

final class PivotalNetworkSource {

    private final Optional<String> apiToken;

    private final Optional<String> artifactPattern;

    private final Optional<String> product;

    @JsonCreator
    PivotalNetworkSource(@JsonProperty("api_token") Optional<String> apiToken,
                         @JsonProperty("artifact_pattern") Optional<String> artifactPattern,
                         @JsonProperty("product") Optional<String> product) {

        this.apiToken = apiToken;
        this.artifactPattern = artifactPattern;
        this.product = product;
    }

    Optional<String> getApiToken() {
        return this.apiToken;
    }

    Optional<String> getArtifactPattern() {
        return this.artifactPattern;
    }

    Optional<String> getProduct() {
        return this.product;
    }

}
