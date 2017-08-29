/*
 * Copyright 2017 the original author or authors.
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

package org.cloudfoundry.dependency.resource.yourkit;

import org.cloudfoundry.dependency.resource.ArtifactMetadata;
import org.cloudfoundry.dependency.resource.InAction;
import org.cloudfoundry.dependency.resource.OutputUtils;
import org.cloudfoundry.dependency.resource.VersionHolder;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Flux;
import reactor.ipc.netty.http.client.HttpClient;

import java.nio.file.Path;

import static org.cloudfoundry.dependency.resource.CommonUtils.getArtifactName;
import static org.cloudfoundry.dependency.resource.CommonUtils.requestArtifact;

@Component
@Profile("in")
final class YourKitInAction extends InAction {

    private final HttpClient httpClient;

    private final YourKitInRequest request;

    YourKitInAction(Path destination, YourKitInRequest request, OutputUtils outputUtils, HttpClient httpClient) {
        super(destination, request, outputUtils);
        this.httpClient = httpClient;
        this.request = request;
    }

    @Override
    protected Flux<ArtifactMetadata> doRun() {
        String artifactUri = getArtifactUri();
        String artifactName = getArtifactName(artifactUri);

        return requestArtifact(this.httpClient, artifactUri)
            .map(content -> writeArtifact(artifactName, content))
            .map(digests -> new ArtifactMetadata(digests, artifactName, artifactUri))
            .flux();
    }

    private String getArtifactUri() {
        VersionHolder version = new VersionHolder(this.request.getVersion().getRef());

        return String.format("https://www.yourkit.com/download/YourKit-JavaProfiler-%04d.%02d-b%02d.zip", version.getMajor(), version.getMinor(), version.getMicro());
    }

}
